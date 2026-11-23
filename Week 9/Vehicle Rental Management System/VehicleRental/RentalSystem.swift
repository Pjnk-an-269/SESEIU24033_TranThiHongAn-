import Foundation

/// Owns the fleet, customer register, daily status overrides, and all rental contracts.
final class VehicleRentalSystem {
    private var vehicles: [String: Vehicle] = [:]
    private var customers: [String: Customer] = [:]
    private var rentals: [String: Rental] = [:]
    private var dailyStatusOverrides: [String: [Date: VehicleDailyStatus]] = [:]

    /// The business date is injectable so schedules and demonstrations are deterministic.
    let today: Date

    init(today: Date = Date()) {
        self.today = RentalDate.day(today)
    }

    func addVehicle(_ vehicle: Vehicle) throws {
        guard vehicles[vehicle.id] == nil else { throw RentalSystemError.duplicateVehicle(vehicle.id) }
        vehicles[vehicle.id] = vehicle
    }

    func vehicle(withID id: String) throws -> Vehicle {
        guard let vehicle = vehicles[id] else { throw RentalSystemError.vehicleNotFound(id) }
        return vehicle
    }

    func allVehicles() -> [Vehicle] { vehicles.values.sorted { $0.id < $1.id } }

    func availableVehicles() -> [Vehicle] {
        allVehicles().filter { (try? vehicleStatus(vehicleID: $0.id, on: today)) == .available }
    }

    func updateVehicle(id: String, make: String, model: String, dailyRateCents: Int) throws {
        try vehicle(withID: id).updateCommonInfo(make: make, model: model, dailyRateCents: dailyRateCents)
    }

    func updateCar(id: String, seatingCapacity: Int, serviceChargeCents: Int) throws {
        guard let car = try vehicle(withID: id) as? Car else {
            throw RentalSystemError.wrongVehicleType("Vehicle '\(id)' is not a car.")
        }
        try car.updateCarDetails(seatingCapacity: seatingCapacity, serviceChargeCents: serviceChargeCents)
    }

    func updateMotorcycle(id: String, engineCapacityCC: Int) throws {
        guard let motorcycle = try vehicle(withID: id) as? Motorcycle else {
            throw RentalSystemError.wrongVehicleType("Vehicle '\(id)' is not a motorcycle.")
        }
        try motorcycle.updateEngineCapacity(engineCapacityCC)
    }

    func updateElectricBicycle(id: String, batteryRangeKM: Int, serviceFeeCents: Int) throws {
        guard let bicycle = try vehicle(withID: id) as? ElectricBicycle else {
            throw RentalSystemError.wrongVehicleType("Vehicle '\(id)' is not an electric bicycle.")
        }
        try bicycle.updateBatteryDetails(rangeKM: batteryRangeKM, serviceFeeCents: serviceFeeCents)
    }

    func registerCustomer(_ customer: Customer) throws {
        guard customers[customer.id] == nil else { throw RentalSystemError.duplicateCustomer(customer.id) }
        customers[customer.id] = customer
    }

    func customer(withID id: String) throws -> Customer {
        guard let customer = customers[id] else { throw RentalSystemError.customerNotFound(id) }
        return customer
    }

    func allCustomers() -> [Customer] { customers.values.sorted { $0.id < $1.id } }

    func updateCustomerContact(id: String, email: String, phone: String) throws {
        try customer(withID: id).updateContact(email: email, phone: phone)
    }

    /// Sets a manual status override for one calendar day.
    func updateVehicleDailyStatus(vehicleID: String, on date: Date, state: VehicleDailyStatus) throws {
        _ = try vehicle(withID: vehicleID)
        let day = RentalDate.day(date)
        dailyStatusOverrides[vehicleID, default: [:]][day] = state
        try synchronizeTodayAvailability(for: vehicleID)
    }

    /// Maintenance overrides scheduled rentals. Otherwise bookings take precedence over manual Rented;
    /// a manual Available value never cancels a confirmed rental contract.
    func vehicleStatus(vehicleID: String, on date: Date) throws -> VehicleDailyStatus {
        _ = try vehicle(withID: vehicleID)
        let day = RentalDate.day(date)
        let manualState = dailyStatusOverrides[vehicleID]?[day]
        if manualState == .maintenance { return .maintenance }

        let hasRental = rentals.values.contains {
            $0.vehicle.id == vehicleID && $0.occupies(day)
        }
        if hasRental || manualState == .rented { return .rented }
        return .available
    }

    /// Checks every day in the half-open interval [from, from + forDays).
    func predictAvailability(vehicleID: String, from date: Date, forDays days: Int) throws -> Bool {
        guard days > 0 else { throw RentalSystemError.invalidInput("Rental duration must be at least one day.") }
        _ = try vehicle(withID: vehicleID)
        for offset in 0..<days {
            let day = RentalDate.adding(days: offset, to: date)
            if try vehicleStatus(vehicleID: vehicleID, on: day) != .available { return false }
        }
        return true
    }

    /// Starts a rental on the system's current business date.
    func rent(vehicleID: String, to customerID: String, forDays days: Int,
              rentalID: String = UUID().uuidString) throws -> Rental {
        try book(vehicleID: vehicleID, to: customerID, from: today, forDays: days, rentalID: rentalID)
    }

    /// Creates a contract for a specific start date. Past dates are accepted for importing rental history.
    func book(vehicleID: String, to customerID: String, from startDate: Date, forDays days: Int,
              rentalID: String = UUID().uuidString) throws -> Rental {
        guard days > 0 else { throw RentalSystemError.invalidInput("Rental duration must be at least one day.") }
        let vehicle = try vehicle(withID: vehicleID)
        let customer = try customer(withID: customerID)
        guard rentals[rentalID] == nil else {
            throw RentalSystemError.invalidInput("A rental with ID '\(rentalID)' already exists.")
        }
        let normalizedStart = RentalDate.day(startDate)
        guard try predictAvailability(vehicleID: vehicleID, from: normalizedStart, forDays: days) else {
            throw RentalSystemError.vehicleUnavailable(vehicleID)
        }

        // Dynamic dispatch applies the vehicle subtype's pricing policy.
        let cost = try vehicle.rentalCostCents(forDays: days)
        let endDateExclusive = RentalDate.adding(days: days, to: normalizedStart)
        let initialStatus: RentalStatus
        let returnedAt: Date?
        if normalizedStart > today {
            initialStatus = .scheduled
            returnedAt = nil
        } else if endDateExclusive <= today {
            initialStatus = .returned
            returnedAt = endDateExclusive
        } else {
            initialStatus = .active
            returnedAt = nil
        }

        let rental = Rental(id: rentalID, customer: customer, vehicle: vehicle,
                            startDay: normalizedStart, durationDays: days, totalCostCents: cost,
                            status: initialStatus, returnedAt: returnedAt)
        rentals[rentalID] = rental
        customer.recordRental(id: rentalID)
        try synchronizeTodayAvailability(for: vehicleID)
        return rental
    }

    @discardableResult
    func returnVehicle(rentalID: String) throws -> Rental {
        guard let rental = rentals[rentalID] else { throw RentalSystemError.rentalNotFound(rentalID) }
        guard rental.status == .active else { throw RentalSystemError.rentalAlreadyReturned(rentalID) }
        try rental.markReturned(at: today)
        try synchronizeTodayAvailability(for: rental.vehicle.id)
        return rental
    }

    func rental(withID id: String) throws -> Rental {
        guard let rental = rentals[id] else { throw RentalSystemError.rentalNotFound(id) }
        return rental
    }

    func rentalHistory(forCustomerID customerID: String) throws -> [Rental] {
        let customer = try customer(withID: customerID)
        return customer.rentalIDs.compactMap { rentals[$0] }
    }

    func allRentals() -> [Rental] { rentals.values.sorted { $0.startDay < $1.startDay } }
    func activeRentals() -> [Rental] { allRentals().filter { $0.status == .active } }
    func scheduledRentals() -> [Rental] { allRentals().filter { $0.status == .scheduled } }

    /// Monthly reporting uses each contract's start month as its revenue recognition month.
    func rentalsInMonth(year: Int, month: Int) throws -> [Rental] {
        guard year > 0, (1...12).contains(month) else {
            throw RentalSystemError.invalidInput("Year and month must be valid calendar values.")
        }
        return allRentals().filter {
            let components = RentalDate.calendar.dateComponents([.year, .month], from: $0.startDay)
            return components.year == year && components.month == month
        }
    }

    func monthlyRevenueCents(year: Int, month: Int) throws -> Int {
        try rentalsInMonth(year: year, month: month).reduce(into: 0) { total, rental in
            let (sum, overflow) = total.addingReportingOverflow(rental.totalCostCents)
            guard !overflow else {
                throw RentalSystemError.invalidInput("Monthly revenue is too large to calculate.")
            }
            total = sum
        }
    }

    private func synchronizeTodayAvailability(for vehicleID: String) throws {
        let status = try vehicleStatus(vehicleID: vehicleID, on: today)
        try vehicle(withID: vehicleID).synchronizeTodayAvailability(status == .available)
    }
}
