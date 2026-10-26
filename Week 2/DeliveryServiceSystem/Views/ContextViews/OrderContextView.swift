import Foundation

/// Renders the context-specific information supplied polymorphically by one order.
enum OrderContextView {
    static func render(order: DeliveryOrder) -> String {
        let divider = String(repeating: "-", count: 56)

        return """
        \(divider)
        Order ID: \(order.orderID)
        Customer: \(order.customerName)
        Delivery Address: \(order.deliveryAddress)
        Service: \(order.getServiceName())
        Order Value: \(formatCurrency(order.orderValue))
        Delivery Fee: \(formatCurrency(order.calculateDeliveryFee()))
        Estimated Delivery: \(order.getEstimatedDeliveryTime())
        \(divider)
        """
    }

    static func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0

        let number = NSNumber(value: value)
        return "\(formatter.string(from: number) ?? String(format: "%.0f", value)) VND"
    }
}
