import Foundation

/// A delivery order guaranteed to arrive on the day it is placed.
final class SameDayDeliveryOrder: DeliveryOrder {
    private let deliveryFee: Double = 60_000

    override func calculateDeliveryFee() -> Double {
        deliveryFee
    }

    override func getEstimatedDeliveryTime() -> String {
        "Same day"
    }

    override func getServiceName() -> String {
        "Same-Day Delivery"
    }
}
