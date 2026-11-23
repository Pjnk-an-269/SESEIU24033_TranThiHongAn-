import Foundation

/// Owns the fleet, customer register, and rental records; all business operations pass through it.
final class VehicleRentalSystem {
    private var vehicles: [String: Vehicle] = [:]
    private var customers: [String: Customer] = [:]
    private var rentals: [String: Rental] = [:]

    func addVehicle(_ vehicle: Vehicle) throws {
        guard vehicles[vehicle.id] == nil else { throw RentalSystemError.duplicateVehicle(vehicle.id) }
        vehicles[vehicle.id] = vehicle
    }

    func vehicle(withID id: String) throws -> Vehicle {
        guard let vehicle = vehicles[id] else { throw RentalSystemError.vehicleNotFound(id) }
        return vehicle
    }

    func allVehicles() -> [Vehicle] { vehicles.values.sorted { $0.id < $1.id } }
    func availableVehicles() -> [Vehicle] { allVehicles().filter(\.isAvailable) }

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

    func rent(vehicleID: String, to customerID: String, forDays days: Int,
              rentalID: String = UUID().uuidString) throws -> Rental {
        guard days > 0 else { throw RentalSystemError.invalidInput("Rental duration must be at least one day.") }
        let vehicle = try vehicle(withID: vehicleID)
        let customer = try customer(withID: customerID)
        guard vehicle.isAvailable else { throw RentalSystemError.vehicleUnavailable(vehicleID) }
        guard rentals[rentalID] == nil else {
            throw RentalSystemError.invalidInput("A rental with ID '\(rentalID)' already exists.")
        }

        // Dynamic dispatch selects the cost policy implemented by Car, Motorcycle, or ElectricBicycle.
        let cost = try vehicle.rentalCostCents(forDays: days)
        try vehicle.reserve()
        let rental = Rental(id: rentalID, customer: customer, vehicle: vehicle,
                            durationDays: days, totalCostCents: cost)
        rentals[rentalID] = rental
        customer.recordRental(id: rentalID)
        return rental
    }

    @discardableResult
    func returnVehicle(rentalID: String) throws -> Rental {
        guard let rental = rentals[rentalID] else { throw RentalSystemError.rentalNotFound(rentalID) }
        guard rental.status == .active else { throw RentalSystemError.rentalAlreadyReturned(rentalID) }
        try rental.markReturned()
        rental.vehicle.release()
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

    func allRentals() -> [Rental] { rentals.values.sorted { $0.startedAt < $1.startedAt } }
    func activeRentals() -> [Rental] { allRentals().filter { $0.status == .active } }
}
