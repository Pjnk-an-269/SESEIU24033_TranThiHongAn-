import Foundation

/// A fixed-price delivery service with a one-to-two-day delivery estimate.
final class ExpressDeliveryOrder: DeliveryOrder {
    override func calculateDeliveryFee() -> Decimal {
        40_000
    }

    override func getEstimatedDeliveryTime() -> String {
        "1-2 days"
    }

    override func getServiceName() -> String {
        "Express Delivery"
    }
}
