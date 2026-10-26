import Foundation

/// Renders the complete delivery-management report to the console.
struct ConsoleView {
    func renderSystemReport(for manager: DeliveryManager) -> String {
        let orderContextView = OrderContextView()
        var reportSections: [String] = []

        reportSections.append(renderSummary(for: manager, currencyFormatter: orderContextView))
        reportSections.append(renderServiceBreakdown(for: manager, currencyFormatter: orderContextView))

        let orderDetails = manager.orders
            .map { orderContextView.render(order: $0) }
            .joined(separator: "\n\n")
        reportSections.append("ORDER DETAILS\n\(orderDetails.isEmpty ? "No orders available." : orderDetails)")

        return reportSections.joined(separator: "\n\n")
    }

    func displaySystemReport(for manager: DeliveryManager) {
        print(renderSystemReport(for: manager))
    }

    private func renderSummary(for manager: DeliveryManager, currencyFormatter: OrderContextView) -> String {
        [
            "DELIVERY SERVICE MANAGEMENT SYSTEM",
            "==================================",
            "Total Orders: \(manager.orders.count)",
            "Total Order Value: \(currencyFormatter.formatCurrency(manager.totalOrderValue()))",
            "Total Delivery Fees: \(currencyFormatter.formatCurrency(manager.totalDeliveryFees()))"
        ].joined(separator: "\n")
    }

    private func renderServiceBreakdown(for manager: DeliveryManager, currencyFormatter: OrderContextView) -> String {
        let rows = manager.statisticsByService().map { statistic in
            [
                "Service: \(statistic.serviceName)",
                "Orders: \(statistic.orderCount)",
                "Order Value Revenue: \(currencyFormatter.formatCurrency(statistic.totalOrderValue))",
                "Delivery Fee Revenue: \(currencyFormatter.formatCurrency(statistic.totalDeliveryFees))"
            ].joined(separator: " | ")
        }

        let content = rows.isEmpty ? "No service statistics available." : rows.joined(separator: "\n")
        return "SERVICE BREAKDOWN\n\(content)"
    }
}
