import Foundation

enum RentalSystemError: Error, LocalizedError {
    case invalidInput(String)
    case duplicateVehicle(String)
    case duplicateCustomer(String)
    case vehicleNotFound(String)
    case customerNotFound(String)
    case rentalNotFound(String)
    case vehicleUnavailable(String)
    case rentalAlreadyReturned(String)
    case wrongVehicleType(String)

    var errorDescription: String? {
        switch self {
        case .invalidInput(let message): return message
        case .duplicateVehicle(let id): return "A vehicle with ID '\(id)' already exists."
        case .duplicateCustomer(let id): return "A customer with ID '\(id)' already exists."
        case .vehicleNotFound(let id): return "No vehicle was found with ID '\(id)'."
        case .customerNotFound(let id): return "No customer was found with ID '\(id)'."
        case .rentalNotFound(let id): return "No rental was found with ID '\(id)'."
        case .vehicleUnavailable(let id): return "Vehicle '\(id)' is currently rented and unavailable."
        case .rentalAlreadyReturned(let id): return "Rental '\(id)' has already been returned."
        case .wrongVehicleType(let message): return message
        }
    }
}

enum VehicleKind: String {
    case car = "Car"
    case motorcycle = "Motorcycle"
    case electricBicycle = "Electric bicycle"
}

/// Base class for all rentable vehicles. Subclasses provide their own pricing policy.
class Vehicle {
    let id: String
    let kind: VehicleKind
    private(set) var make: String
    private(set) var model: String
    private(set) var dailyRateCents: Int
    private(set) var isAvailable = true

    init(id: String, kind: VehicleKind, make: String, model: String, dailyRateCents: Int) throws {
        guard !id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw RentalSystemError.invalidInput("Vehicle ID cannot be empty.")
        }
        guard !make.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !model.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw RentalSystemError.invalidInput("Vehicle make and model cannot be empty.")
        }
        guard dailyRateCents >= 0 else {
            throw RentalSystemError.invalidInput("Daily rate cannot be negative.")
        }
        self.id = id
        self.kind = kind
        self.make = make
        self.model = model
        self.dailyRateCents = dailyRateCents
    }

    /// Override in each vehicle type to apply its own rental pricing policy.
    func rentalCostCents(forDays days: Int) throws -> Int {
        throw RentalSystemError.invalidInput("This vehicle type does not define a rental pricing policy.")
    }

    func detailLines() -> [String] { [] }

    func updateCommonInfo(make: String, model: String, dailyRateCents: Int) throws {
        guard !make.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !model.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw RentalSystemError.invalidInput("Vehicle make and model cannot be empty.")
        }
        guard dailyRateCents >= 0 else {
            throw RentalSystemError.invalidInput("Daily rate cannot be negative.")
        }
        self.make = make
        self.model = model
        self.dailyRateCents = dailyRateCents
    }

    func reserve() throws {
        guard isAvailable else { throw RentalSystemError.vehicleUnavailable(id) }
        isAvailable = false
    }

    func release() { isAvailable = true }

    var summary: String {
        "\(id) | \(kind.rawValue) | \(make) \(model) | \(Money.format(dailyRateCents))/day | \(isAvailable ? "Available" : "Rented")"
    }
}

final class Car: Vehicle {
    private(set) var seatingCapacity: Int
    private(set) var serviceChargeCents: Int

    init(id: String, make: String, model: String, dailyRateCents: Int,
         seatingCapacity: Int, serviceChargeCents: Int) throws {
        guard seatingCapacity > 0 else {
            throw RentalSystemError.invalidInput("Car seating capacity must be greater than zero.")
        }
        guard serviceChargeCents >= 0 else {
            throw RentalSystemError.invalidInput("Car service charge cannot be negative.")
        }
        self.seatingCapacity = seatingCapacity
        self.serviceChargeCents = serviceChargeCents
        try super.init(id: id, kind: .car, make: make, model: model, dailyRateCents: dailyRateCents)
    }

    override func rentalCostCents(forDays days: Int) throws -> Int {
        try validateRentalDays(days)
        return try checkedTotal(dailyRateCents, days: days, oneTimeFeeCents: serviceChargeCents)
    }

    override func detailLines() -> [String] {
        ["Seats: \(seatingCapacity)", "Service charge: \(Money.format(serviceChargeCents)) per rental"]
    }

    func updateCarDetails(seatingCapacity: Int, serviceChargeCents: Int) throws {
        guard seatingCapacity > 0 else {
            throw RentalSystemError.invalidInput("Car seating capacity must be greater than zero.")
        }
        guard serviceChargeCents >= 0 else {
            throw RentalSystemError.invalidInput("Car service charge cannot be negative.")
        }
        self.seatingCapacity = seatingCapacity
        self.serviceChargeCents = serviceChargeCents
    }
}

enum EngineCategory: String {
    case light = "Light (up to 150 cc)"
    case standard = "Standard (151–500 cc)"
    case heavy = "Heavy (over 500 cc)"

    var dailySurchargeCents: Int {
        switch self {
        case .light: return 0
        case .standard: return 500
        case .heavy: return 1_000
        }
    }

    static func forCapacity(_ cc: Int) throws -> EngineCategory {
        guard cc > 0 else { throw RentalSystemError.invalidInput("Engine capacity must be greater than zero.") }
        if cc <= 150 { return .light }
        if cc <= 500 { return .standard }
        return .heavy
    }
}

final class Motorcycle: Vehicle {
    private(set) var engineCapacityCC: Int
    var engineCategory: EngineCategory { (try? EngineCategory.forCapacity(engineCapacityCC)) ?? .light }

    init(id: String, make: String, model: String, dailyRateCents: Int, engineCapacityCC: Int) throws {
        _ = try EngineCategory.forCapacity(engineCapacityCC)
        self.engineCapacityCC = engineCapacityCC
        try super.init(id: id, kind: .motorcycle, make: make, model: model, dailyRateCents: dailyRateCents)
    }

    override func rentalCostCents(forDays days: Int) throws -> Int {
        try validateRentalDays(days)
        let (adjustedDailyRate, overflow) = dailyRateCents.addingReportingOverflow(engineCategory.dailySurchargeCents)
        guard !overflow else { throw RentalSystemError.invalidInput("Rental cost is too large to calculate.") }
        return try checkedTotal(adjustedDailyRate, days: days)
    }

    override func detailLines() -> [String] {
        ["Engine: \(engineCapacityCC) cc (\(engineCategory.rawValue))",
         "Category surcharge: \(Money.format(engineCategory.dailySurchargeCents))/day"]
    }

    func updateEngineCapacity(_ cc: Int) throws {
        _ = try EngineCategory.forCapacity(cc)
        engineCapacityCC = cc
    }
}

final class ElectricBicycle: Vehicle {
    private(set) var batteryRangeKM: Int
    private(set) var batteryServiceFeeCents: Int

    init(id: String, make: String, model: String, dailyRateCents: Int,
         batteryRangeKM: Int, batteryServiceFeeCents: Int) throws {
        guard batteryRangeKM > 0 else {
            throw RentalSystemError.invalidInput("Battery range must be greater than zero.")
        }
        guard batteryServiceFeeCents >= 0 else {
            throw RentalSystemError.invalidInput("Battery service fee cannot be negative.")
        }
        self.batteryRangeKM = batteryRangeKM
        self.batteryServiceFeeCents = batteryServiceFeeCents
        try super.init(id: id, kind: .electricBicycle, make: make, model: model, dailyRateCents: dailyRateCents)
    }

    override func rentalCostCents(forDays days: Int) throws -> Int {
        try validateRentalDays(days)
        return try checkedTotal(dailyRateCents, days: days, oneTimeFeeCents: batteryServiceFeeCents)
    }

    override func detailLines() -> [String] {
        ["Battery range: \(batteryRangeKM) km",
         "Battery service fee: \(Money.format(batteryServiceFeeCents)) per rental"]
    }

    func updateBatteryDetails(rangeKM: Int, serviceFeeCents: Int) throws {
        guard rangeKM > 0 else { throw RentalSystemError.invalidInput("Battery range must be greater than zero.") }
        guard serviceFeeCents >= 0 else { throw RentalSystemError.invalidInput("Battery service fee cannot be negative.") }
        batteryRangeKM = rangeKM
        batteryServiceFeeCents = serviceFeeCents
    }
}

final class Customer {
    let id: String
    private(set) var name: String
    private(set) var email: String
    private(set) var phone: String
    private(set) var rentalIDs: [String] = []

    init(id: String, name: String, email: String, phone: String) throws {
        guard !id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw RentalSystemError.invalidInput("Customer ID cannot be empty.")
        }
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw RentalSystemError.invalidInput("Customer name cannot be empty.")
        }
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw RentalSystemError.invalidInput("Customer email and phone cannot be empty.")
        }
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
    }

    func updateContact(email: String, phone: String) throws {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw RentalSystemError.invalidInput("Customer email and phone cannot be empty.")
        }
        self.email = email
        self.phone = phone
    }

    func recordRental(id: String) { rentalIDs.append(id) }

    var summary: String { "\(id) | \(name) | \(email) | \(phone)" }
}

enum RentalStatus: String {
    case active = "Active"
    case returned = "Returned"
}

final class Rental {
    let id: String
    let customer: Customer
    let vehicle: Vehicle
    let startDay: Date
    let endDay: Date
    let durationDays: Int
    let totalCostCents: Int
    private(set) var status: RentalStatus = .active
    private(set) var returnedAt: Date?

    init(id: String, customer: Customer, vehicle: Vehicle, startDay: Date,
         durationDays: Int, totalCostCents: Int) {
        self.id = id
        self.customer = customer
        self.vehicle = vehicle
        self.startDay = startDay
        self.durationDays = durationDays
        self.endDay = Calendar.current.date(byAdding: .day, value: durationDays, to: startDay) ?? startDay
        self.totalCostCents = totalCostCents
    }

    func markReturned(at date: Date = Date()) throws {
        guard status == .active else { throw RentalSystemError.rentalAlreadyReturned(id) }
        status = .returned
        returnedAt = date
    }

    var receipt: String {
        let startStr = DateFormatHelper.format(startDay)
        let endStr = DateFormatHelper.format(endDay)
        return "Rental \(id) | \(customer.name) | \(vehicle.make) \(vehicle.model) (\(vehicle.id)) | \(startStr) to \(endStr) (\(durationDays) day(s)) | \(Money.format(totalCostCents)) | \(status.rawValue)"
    }
}

enum DateFormatHelper {
    private static let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()

    static func format(_ date: Date) -> String {
        formatter.string(from: date)
    }

    static func date(year: Int, month: Int, day: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }
}

enum Money {
    static func format(_ cents: Int) -> String {
        String(format: "$%.2f", Double(cents) / 100.0)
    }
}

private func validateRentalDays(_ days: Int) throws {
    guard days > 0 else { throw RentalSystemError.invalidInput("Rental duration must be at least one day.") }
}

private func checkedTotal(_ dailyRateCents: Int, days: Int, oneTimeFeeCents: Int = 0) throws -> Int {
    let (dailyTotal, multiplyOverflow) = dailyRateCents.multipliedReportingOverflow(by: days)
    let (total, additionOverflow) = dailyTotal.addingReportingOverflow(oneTimeFeeCents)
    guard !multiplyOverflow, !additionOverflow else {
        throw RentalSystemError.invalidInput("Rental cost is too large to calculate.")
    }
    return total
}
