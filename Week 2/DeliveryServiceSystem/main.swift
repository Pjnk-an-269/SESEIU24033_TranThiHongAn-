import Foundation

let manager = DeliveryManager()

let sampleOrders: [DeliveryOrder] = [
    StandardDeliveryOrder(
        orderID: "STD-1001",
        customerName: "Nguyen Minh Anh",
        deliveryAddress: "District 1, Ho Chi Minh City",
        orderValue: 350_000
    ),
    ExpressDeliveryOrder(
        orderID: "EXP-1002",
        customerName: "Tran Gia Bao",
        deliveryAddress: "Hai Chau District, Da Nang",
        orderValue: 1_250_000
    ),
    SameDayDeliveryOrder(
        orderID: "SMD-1003",
        customerName: "Le Thu Ha",
        deliveryAddress: "Hoan Kiem District, Hanoi",
        orderValue: 780_000
    ),
    StandardDeliveryOrder(
        orderID: "STD-1004",
        customerName: "Pham Quang Huy",
        deliveryAddress: "Ninh Kieu District, Can Tho",
        orderValue: 500_000
    ),
    ExpressDeliveryOrder(
        orderID: "EXP-1005",
        customerName: "Vo Khanh Linh",
        deliveryAddress: "Thu Duc City, Ho Chi Minh City",
        orderValue: 920_000
    )
].compactMap { $0 }

for order in sampleOrders {
    guard manager.addOrder(order) else {
        fatalError("Sample order IDs must be unique.")
    }
}

ConsoleView.printOrders(manager.orders)

// Linear search demonstration.
ConsoleView.printSearchResult(manager.findOrderByID("EXP-1002"), searchedID: "EXP-1002")

// In-place array sort demonstration.
manager.sortOrdersByValue(ascending: false)
ConsoleView.printOrders(manager.orders, title: "Orders by Value (Highest First)")

// Array filter demonstration.
let expressOrders = manager.filterOrders(byServiceName: "Express Delivery")
ConsoleView.printOrders(expressOrders, title: "Express Delivery Orders")

// Aggregation reports.
ConsoleView.printCategoryBreakdown(for: manager)
ConsoleView.printRevenueSummary(for: manager)
