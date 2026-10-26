import Foundation

/// Provides formatted console reports without owning business state.
enum ConsoleView {
    static func printOrders(_ orders: [DeliveryOrder], title: String = "All Delivery Orders") {
        printSection(title)

        guard !orders.isEmpty else {
            print("No orders found.")
            return
        }

        orders.forEach { order in
            print(OrderContextView.render(order: order))
        }
    }

    static func printCategoryBreakdown(for manager: DeliveryManager) {
        printSection("Category Breakdown")

        let groupedOrders = Dictionary(grouping: manager.orders, by: { $0.getServiceName() })
        guard !groupedOrders.isEmpty else {
            print("No orders found.")
            return
        }

        for serviceName in groupedOrders.keys.sorted() {
            let categoryOrders = groupedOrders[serviceName] ?? []
            let categoryFee = manager.calculateTotalFee(forServiceName: serviceName)
            print("\(serviceName): \(categoryOrders.count) order(s), delivery fees: \(OrderContextView.formatCurrency(categoryFee))")
        }
    }

    static func printRevenueSummary(for manager: DeliveryManager) {
        printSection("Revenue Summary")

        let totalOrderValue = manager.orders.reduce(0) { partialTotal, order in
            partialTotal + order.orderValue
        }

        print("Total Orders: \(manager.orders.count)")
        print("Total Order Value: \(OrderContextView.formatCurrency(totalOrderValue))")
        print("Total Delivery Fees: \(OrderContextView.formatCurrency(manager.calculateTotalDeliveryFees()))")
    }

    static func printSearchResult(_ order: DeliveryOrder?, searchedID: String) {
        printSection("Search Result: \(searchedID)")

        guard let order else {
            print("No order found with ID '\(searchedID)'.")
            return
        }

        print(OrderContextView.render(order: order))
    }

    private static func printSection(_ title: String) {
        print("\n\(String(repeating: "=", count: 56))")
        print(title)
        print(String(repeating: "=", count: 56))
    }
}
