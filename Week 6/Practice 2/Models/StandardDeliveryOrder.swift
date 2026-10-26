import Foundation

/// A fixed-price delivery service with a three-to-five-day delivery estimate.
final class StandardDeliveryOrder: DeliveryOrder {
    override func calculateDeliveryFee() -> Decimal {
        20_000
    }

    override func getEstimatedDeliveryTime() -> String {
        "3-5 days"
    }

    override func getServiceName() -> String {
        "Standard Delivery"
    }
}
