import Foundation

do {
    let deliveryManager = DeliveryManager()

    let standardOrder = try StandardDeliveryOrder(
        orderID: "STD-1001",
        customerName: "Nguyen Minh Anh",
        deliveryAddress: "District 1, Ho Chi Minh City",
        orderValue: 1_250_000
    )

    let expressOrder = try ExpressDeliveryOrder(
        orderID: "EXP-1002",
        customerName: "Tran Gia Bao",
        deliveryAddress: "Hai Chau District, Da Nang",
        orderValue: 2_500_000
    )

    let sameDayOrder = try SameDayDeliveryOrder(
        orderID: "SMD-1003",
        customerName: "Le Thu Ha",
        deliveryAddress: "Cau Giay District, Hanoi",
        orderValue: 980_000
    )

    try deliveryManager.addOrder(standardOrder)
    try deliveryManager.addOrder(expressOrder)
    try deliveryManager.addOrder(sameDayOrder)

    ConsoleView().displaySystemReport(for: deliveryManager)
} catch {
    fputs("Unable to initialize the delivery service system: \(error.localizedDescription)\n", stderr)
}
