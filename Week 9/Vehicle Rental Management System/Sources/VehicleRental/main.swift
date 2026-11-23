import Foundation

func printVehicleDetails(_ vehicle: Vehicle) {
    print(vehicle.summary)
    for detail in vehicle.detailLines() { print("  \(detail)") }
}

func prompt(_ label: String) -> String {
    print(label, terminator: " ")
    return readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
}

func seedSampleData(into system: VehicleRentalSystem) throws {
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
}

func runInteractiveMenu(with system: VehicleRentalSystem) {
    while true {
        print("""

        ==========================================
           VEHICLE RENTAL MANAGEMENT SYSTEM
        ==========================================
        1. Display all vehicles
        2. Display available vehicles
        3. Add a new vehicle
        4. Register a new customer
        5. View all customers & rental history
        6. Rent a vehicle
        7. Return a vehicle
        8. View active rentals
        0. Exit
        ------------------------------------------
        """)

        let choice = prompt("Select an option:")

        do {
            switch choice {
            case "1":
                print("\n--- All Vehicles ---")
                for vehicle in system.allVehicles() { printVehicleDetails(vehicle) }

            case "2":
                print("\n--- Available Vehicles ---")
                let available = system.availableVehicles()
                if available.isEmpty {
                    print("No vehicles available right now.")
                } else {
                    for vehicle in available { printVehicleDetails(vehicle) }
                }

            case "3":
                print("\nVehicle Type: [1] Car | [2] Motorcycle | [3] Electric Bicycle")
                let type = prompt("Choose type (1-3):")
                let id = prompt("Vehicle ID (e.g., CAR-103):")
                let make = prompt("Make (brand):")
                let model = prompt("Model:")
                guard let rate = Int(prompt("Daily rate in cents (e.g., 5000 for $50.00):")) else {
                    throw RentalSystemError.invalidInput("Daily rate must be an integer in cents.")
                }

                switch type {
                case "1":
                    guard let seats = Int(prompt("Seating capacity:")),
                          let fee = Int(prompt("Service charge in cents:")) else {
                        throw RentalSystemError.invalidInput("Seats and service charge must be integers.")
                    }
                    try system.addVehicle(Car(id: id, make: make, model: model, dailyRateCents: rate,
                                              seatingCapacity: seats, serviceChargeCents: fee))
                case "2":
                    guard let cc = Int(prompt("Engine capacity (cc):")) else {
                        throw RentalSystemError.invalidInput("Engine capacity must be an integer.")
                    }
                    try system.addVehicle(Motorcycle(id: id, make: make, model: model, dailyRateCents: rate,
                                                     engineCapacityCC: cc))
                case "3":
                    guard let range = Int(prompt("Battery range (km):")),
                          let fee = Int(prompt("Battery service fee in cents:")) else {
                        throw RentalSystemError.invalidInput("Battery range and fee must be integers.")
                    }
                    try system.addVehicle(ElectricBicycle(id: id, make: make, model: model, dailyRateCents: rate,
                                                          batteryRangeKM: range, batteryServiceFeeCents: fee))
                default:
                    throw RentalSystemError.invalidInput("Invalid vehicle type selected.")
                }
                print("Vehicle '\(id)' added successfully.")

            case "4":
                let id = prompt("Customer ID (e.g., CUST-003):")
                let name = prompt("Full name:")
                let email = prompt("Email:")
                let phone = prompt("Phone number:")
                try system.registerCustomer(Customer(id: id, name: name, email: email, phone: phone))
                print("Customer '\(name)' registered successfully.")

            case "5":
                print("\n--- Registered Customers ---")
                for customer in system.allCustomers() { print(customer.summary) }
                let cusID = prompt("\nEnter Customer ID to view rental history (or press Enter to skip):")
                if !cusID.isEmpty {
                    let history = try system.rentalHistory(forCustomerID: cusID)
                    if history.isEmpty {
                        print("No rental history found for '\(cusID)'.")
                    } else {
                        for rental in history { print(rental.receipt) }
                    }
                }

            case "6":
                let rentalID = prompt("Rental ID (e.g., RENT-001):")
                let cusID = prompt("Customer ID:")
                let vehicleID = prompt("Vehicle ID:")
                guard let days = Int(prompt("Rental duration (days):")) else {
                    throw RentalSystemError.invalidInput("Duration must be a whole number of days.")
                }
                let rental = try system.rent(vehicleID: vehicleID, to: cusID, forDays: days, rentalID: rentalID)
                print("\nRental created successfully:")
                print(rental.receipt)

            case "7":
                let rentalID = prompt("Enter Rental ID to return:")
                let returned = try system.returnVehicle(rentalID: rentalID)
                print("\nVehicle returned successfully:")
                print(returned.receipt)

            case "8":
                print("\n--- Active Rentals ---")
                let active = system.activeRentals()
                if active.isEmpty {
                    print("No active rentals.")
                } else {
                    for rental in active { print(rental.receipt) }
                }

            case "0":
                print("Exiting Vehicle Rental Management System. Goodbye!")
                return

            default:
                print("Invalid option. Please enter a number from 0 to 8.")
            }
        } catch {
            print("Operation failed: \(error.localizedDescription)")
        }
    }
}

do {
    let system = VehicleRentalSystem()
    try seedSampleData(into: system)
    runInteractiveMenu(with: system)
} catch {
    fputs("Initialization failed: \(error.localizedDescription)\n", stderr)
    exit(EXIT_FAILURE)
}
