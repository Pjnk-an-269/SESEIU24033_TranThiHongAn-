import Foundation

struct CartItem: Identifiable, Equatable {
    let id = UUID()
    var product: Product
    var quantity: Int

    var totalPrice: Double {
        product.price * Double(quantity)
    }
}

extension CartItem {
    static func samples(products: [Product]) -> [CartItem] {
        Array(products.prefix(2)).map { product in
            CartItem(product: product, quantity: 1)
        }
    }
}
