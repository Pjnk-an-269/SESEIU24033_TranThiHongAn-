import Foundation

/// Formats the context-specific details of one polymorphic delivery order.
struct OrderContextView {
    func render(order: DeliveryOrder) -> String {
        [
            "Order ID: \(order.orderID)",
            "Customer: \(order.customerName)",
            "Delivery Address: \(order.deliveryAddress)",
            "Service: \(order.getServiceName())",
            "Order Value: \(formatCurrency(order.orderValue))",
            "Delivery Fee: \(formatCurrency(order.calculateDeliveryFee()))",
            "Estimated Delivery: \(order.getEstimatedDeliveryTime())"
        ].joined(separator: "\n")
    }

    func display(order: DeliveryOrder) {
        print(render(order: order))
    }

    func formatCurrency(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0

        let formattedAmount = formatter.string(from: amount as NSDecimalNumber)
            ?? NSDecimalNumber(decimal: amount).stringValue
        return "\(formattedAmount) VND"
    }
}
