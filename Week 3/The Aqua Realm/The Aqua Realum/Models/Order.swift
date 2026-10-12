import Foundation

struct Order: Identifiable, Equatable {
    let id = UUID()
    var customerName: String
    var items: [CartItem]
    var orderDate: Date
    var status: OrderStatus
    var shippingFee: Double

    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice } + shippingFee
    }
}

extension Order {
    static func samples(products: [Product]) -> [Order] {
        [
            Order(
                customerName: "Grace Tran",
                items: CartItem.samples(products: products),
                orderDate: Date(),
                status: .preparing,
                shippingFee: 20000
            )
        ]
    }
}
