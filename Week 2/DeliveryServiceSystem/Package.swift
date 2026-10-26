// swift-tools-version: 5.9
//
// Open this file in Xcode to work with the package. Modern versions of Xcode
// open Swift packages directly; no generated .xcodeproj is required.

import PackageDescription

let package = Package(
    name: "DeliveryServiceSystem",
    products: [
        .executable(
            name: "DeliveryServiceSystem",
            targets: ["DeliveryServiceSystem"]
        )
    ],
    targets: [
        .executableTarget(
            name: "DeliveryServiceSystem",
            path: ".",
            sources: [
                "main.swift",
                "Models/DeliveryOrder.swift",
                "Models/StandardDeliveryOrder.swift",
                "Models/ExpressDeliveryOrder.swift",
                "Models/SameDayDeliveryOrder.swift",
                "Sources/DeliveryManager.swift",
                "Views/ConsoleView.swift",
                "Views/ContextViews/OrderContextView.swift"
            ]
        )
    ]
)
