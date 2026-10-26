import Foundation

/// A delivery order fulfilled in one to two days.
final class ExpressDeliveryOrder: DeliveryOrder {
    private let deliveryFee: Double = 40_000

    override func calculateDeliveryFee() -> Double {
        deliveryFee
    }

    override func getEstimatedDeliveryTime() -> String {
        "1-2 days"
    }

    override func getServiceName() -> String {
        "Express Delivery"
    }
}
