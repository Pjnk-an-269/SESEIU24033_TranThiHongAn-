// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VehicleRentalManagementSystem",
    products: [
        .executable(name: "vehicle-rental", targets: ["VehicleRental"])
    ],
    targets: [
        .executableTarget(name: "VehicleRental")
    ]
)
