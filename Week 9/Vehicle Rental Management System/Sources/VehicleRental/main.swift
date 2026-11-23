import Foundation

func printVehicleDetails(_ vehicle: Vehicle) {
    print(vehicle.summary)
    for detail in vehicle.detailLines() { print("  \(detail)") }
}

func runDemo() throws {
    let system = VehicleRentalSystem()

    // Sample fleet: five vehicles across the three supported types.
    try system.addVehicle(Car(id: "CAR-101", make: "Toyota", model: "Corolla",
                              dailyRateCents: 5_500, seatingCapacity: 5, serviceChargeCents: 1_200))
    try system.addVehicle(Car(id: "CAR-102", make: "Honda", model: "Civic",
                              dailyRateCents: 6_200, seatingCapacity: 5, serviceChargeCents: 1_500))
    try system.addVehicle(Motorcycle(id: "MOTO-201", make: "Honda", model: "Wave",
                                     dailyRateCents: 1_800, engineCapacityCC: 110))
    try system.addVehicle(Motorcycle(id: "MOTO-202", make: "Yamaha", model: "MT-03",
                                     dailyRateCents: 3_000, engineCapacityCC: 321))
    try system.addVehicle(ElectricBicycle(id: "EBIKE-301", make: "Giant", model: "Explore E+",
                                          dailyRateCents: 2_200, batteryRangeKM: 100,
                                          batteryServiceFeeCents: 300))

    try system.registerCustomer(Customer(id: "CUST-001", name: "Linh Nguyen",
                                         email: "linh@example.com", phone: "+84 901 234 567"))
    try system.registerCustomer(Customer(id: "CUST-002", name: "Minh Tran",
                                         email: "minh@example.com", phone: "+84 902 345 678"))

    print("=== VEHICLE RENTAL MANAGEMENT SYSTEM ===")
    print("\nAll vehicles (type-specific details are dispatched polymorphically):")
    for vehicle in system.allVehicles() { printVehicleDetails(vehicle) }

    print("\nRegistered customers:")
    for customer in system.allCustomers() { print(customer.summary) }

    print("\nRentals:")
        let carRental = try system.rent(vehicleID: "CAR-101", to: "CUST-001", forDays: 3,
                                        rentalID: "RENT-001")
        let motorcycleRental = try system.rent(vehicleID: "MOTO-202", to: "CUST-002", forDays: 2,
                                               rentalID: "RENT-002")
        let bicycleRental = try system.rent(vehicleID: "EBIKE-301", to: "CUST-001", forDays: 4,
                                            rentalID: "RENT-003")
    print(carRental.receipt)
    print(motorcycleRental.receipt)
    print(bicycleRental.receipt)

    print("\nActive rentals:")
    for rental in system.activeRentals() { print(rental.receipt) }

    print("\nCustomer rental history (\(carRental.customer.name)):")
    for rental in try system.rentalHistory(forCustomerID: "CUST-001") { print(rental.receipt) }

    print("\nAvailability while rentals are active:")
    for vehicle in system.allVehicles() { print("\(vehicle.id): \(vehicle.isAvailable ? "Available" : "Rented")") }

    print("\nReturn operation:")
    let returned = try system.returnVehicle(rentalID: "RENT-001")
    print(returned.receipt)
    print("\(returned.vehicle.id) is now \(returned.vehicle.isAvailable ? "available" : "rented").")

    print("\nInvalid operation handling:")
    do {
        _ = try system.rent(vehicleID: "EBIKE-301", to: "CUST-002", forDays: 2, rentalID: "RENT-004")
    } catch {
        print("Rental rejected: \(error.localizedDescription)")
    }
    do {
        _ = try system.rent(vehicleID: "CAR-102", to: "CUST-002", forDays: 0, rentalID: "RENT-005")
    } catch {
        print("Rental rejected: \(error.localizedDescription)")
    }

    // Show updates through the controlled system API and customer history remains available.
    try system.updateCustomerContact(id: "CUST-002", email: "minh.tran@example.com", phone: "+84 903 456 789")
    try system.updateVehicle(id: "CAR-102", make: "Honda", model: "Civic EX", dailyRateCents: 6_500)
    print("\nUpdated customer: \(try system.customer(withID: "CUST-002").summary)")
    print("Updated vehicle: \(try system.vehicle(withID: "CAR-102").summary)")
}

do {
    try runDemo()
} catch {
    fputs("Demo failed: \(error.localizedDescription)\n", stderr)
    exit(EXIT_FAILURE)
}
