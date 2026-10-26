import Foundation

/// A delivery order fulfilled in three to five days.
final class StandardDeliveryOrder: DeliveryOrder {
    private let deliveryFee: Double = 20_000

    override func calculateDeliveryFee() -> Double {
        deliveryFee
    }

    override func getEstimatedDeliveryTime() -> String {
        "3-5 days"
    }

    override func getServiceName() -> String {
        "Standard Delivery"
    }
}
