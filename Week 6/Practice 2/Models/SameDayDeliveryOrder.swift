import Foundation

/// A fixed-price premium delivery service fulfilled on the order date.
final class SameDayDeliveryOrder: DeliveryOrder {
    override func calculateDeliveryFee() -> Decimal {
        60_000
    }

    override func getEstimatedDeliveryTime() -> String {
        "Same day"
    }

    override func getServiceName() -> String {
        "Same-Day Delivery"
    }
}
