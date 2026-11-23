import Foundation

func printVehicleDetails(_ vehicle: Vehicle) {
    print(vehicle.summary)
    for detail in vehicle.detailLines() { print("  \(detail)") }
}

func rentalID(_ number: Int) -> String { String(format: "RENT-%03d", number) }

func runDemo() throws {
    let today = try RentalDate.make(year: 2026, month: 11, day: 23)
    let system = VehicleRentalSystem(today: today)

    // 20 vehicles: 7 cars, 7 motorcycles, and 6 electric bicycles.
    var vehicles: [Vehicle] = []
    for number in 1...7 {
        vehicles.append(try Car(id: String(format: "CAR-%02d", number), make: "Toyota",
                                model: "Model \(number)", dailyRateCents: 5_000 + number * 250,
                                seatingCapacity: number.isMultiple(of: 2) ? 7 : 5,
                                serviceChargeCents: 1_000 + number * 100))
    }
    for number in 1...7 {
        vehicles.append(try Motorcycle(id: String(format: "MOTO-%02d", number), make: "Honda",
                                       model: "Moto \(number)", dailyRateCents: 1_800 + number * 100,
                                       engineCapacityCC: 110 + number * 90))
    }
    for number in 1...6 {
        vehicles.append(try ElectricBicycle(id: String(format: "EBIKE-%02d", number), make: "Giant",
                                            model: "E-Bike \(number)", dailyRateCents: 2_000 + number * 100,
                                            batteryRangeKM: 70 + number * 5,
                                            batteryServiceFeeCents: 250 + number * 25))
    }
    for vehicle in vehicles { try system.addVehicle(vehicle) }

    // 20 registered customers.
    var customers: [Customer] = []
    for number in 1...20 {
        let customer = try Customer(id: String(format: "CUST-%02d", number),
                                    name: String(format: "Customer %02d", number),
                                    email: "customer\(number)@example.com",
                                    phone: String(format: "+84 900 %03d %03d", number, 100 + number))
        try system.registerCustomer(customer)
        customers.append(customer)
    }

    // 20 completed historical contracts in October 2026, one per vehicle.
    var nextRentalNumber = 1
    for index in vehicles.indices {
        let date = try RentalDate.make(year: 2026, month: 10, day: index + 1)
        let duration = 2 + index % 3
        _ = try system.book(vehicleID: vehicles[index].id,
                            to: customers[index].id,
                            from: date,
                            forDays: duration,
                            rentalID: rentalID(nextRentalNumber))
        nextRentalNumber += 1
    }

    // 10 rentals spanning the demo's current date (2026-11-23).
    for index in 0..<10 {
        let vehicle = vehicles[index + 2]
        let customer = customers[(index + 5) % customers.count]
        let start = try RentalDate.make(year: 2026, month: 11, day: 21)
        _ = try system.book(vehicleID: vehicle.id, to: customer.id, from: start,
                            forDays: 7, rentalID: rentalID(nextRentalNumber))
        nextRentalNumber += 1
    }

    // 20 future reservations: each of the same 10 vehicles has two non-overlapping bookings.
    for index in 0..<20 {
        let vehicle = vehicles[index % 10 + 2]
        let customer = customers[index % customers.count]
        let start = index < 10
            ? try RentalDate.make(year: 2026, month: 11, day: 30)
            : try RentalDate.make(year: 2026, month: 12, day: 10)
        _ = try system.book(vehicleID: vehicle.id, to: customer.id, from: start,
                            forDays: 3, rentalID: rentalID(nextRentalNumber))
        nextRentalNumber += 1
    }

    print("=== VEHICLE RENTAL MANAGEMENT SYSTEM ===")

    print("\n1. SAMPLE DATA STATISTICS")
    print("Vehicles: \(system.allVehicles().count)")
    print("Customers: \(system.allCustomers().count)")
    print("Contracts: \(system.allRentals().count) (Returned: \(system.allRentals().filter { $0.status == .returned }.count), Active: \(system.activeRentals().count), Scheduled: \(system.scheduledRentals().count))")

    print("\nVehicle and customer information management (view details, update):")
    try system.updateVehicle(id: "EBIKE-06", make: "Giant", model: "E-Bike 06 Plus", dailyRateCents: 2_750)
    try system.updateCustomerContact(id: "CUST-20", email: "customer20.updated@example.com", phone: "+84 909 999 020")
    printVehicleDetails(try system.vehicle(withID: "EBIKE-06"))
    print(try system.customer(withID: "CUST-20").summary)
    let history = try system.rentalHistory(forCustomerID: "CUST-01")
    print("CUST-01 rental history: \(history.count) contract(s)")

    print("\n2. STATUS UPDATE AND VEHICLE AVAILABILITY FORECAST")
    let maintenanceDay = try RentalDate.make(year: 2026, month: 11, day: 25)
    try system.updateVehicleDailyStatus(vehicleID: "CAR-01", on: maintenanceDay, state: .maintenance)
    print("Maintenance set: CAR-01 on \(RentalDate.format(maintenanceDay))")
    for offset in 0...5 {
        let date = RentalDate.adding(days: offset, to: today)
        let label = offset == 0 ? "Today" : "+\(offset)d"
        let state = try system.vehicleStatus(vehicleID: "CAR-01", on: date)
        print("\(label) (\(RentalDate.format(date))): \(state.rawValue)")
    }
    let availableForThreeDays = try system.predictAvailability(vehicleID: "CAR-01", from: today, forDays: 3)
    print("Available for the next 3 days: \(availableForThreeDays ? "YES" : "NO")")

    print("\n3. OCTOBER 2026 REVENUE REPORT(previous month's revenue report)")
    let octoberRentals = try system.rentalsInMonth(year: 2026, month: 10)
    let octoberRevenue = try system.monthlyRevenueCents(year: 2026, month: 10)
    print("Contracts: \(octoberRentals.count)")
    print("Revenue: \(Money.format(octoberRevenue))")

    print("\n4. OVERLAPPING BOOKING REJECTION DEMO")
    do {
        let conflictingStart = try RentalDate.make(year: 2026, month: 11, day: 25)
        _ = try system.book(vehicleID: "CAR-01", to: "CUST-01", from: conflictingStart,
                            forDays: 2, rentalID: "RENT-051")
    } catch {
        print("Maintenance conflict rejected: \(error.localizedDescription)")
    }
    do {
        let conflictingStart = try RentalDate.make(year: 2026, month: 12, day: 1)
        _ = try system.book(vehicleID: "CAR-03", to: "CUST-02", from: conflictingStart,
                            forDays: 2, rentalID: "RENT-052")
    } catch {
        print("Scheduled-rental conflict rejected: \(error.localizedDescription)")
    }

    print("\n5. VEHICLE RETURN DEMO")
    let returned = try system.returnVehicle(rentalID: "RENT-021")
    print(returned.receipt)
    print("\(returned.vehicle.id) status today: \(try system.vehicleStatus(vehicleID: returned.vehicle.id, on: today).rawValue)")
}

do {
    try runDemo()
} catch {
    fputs("Demo failed: \(error.localizedDescription)\n", stderr)
    exit(EXIT_FAILURE)
}
