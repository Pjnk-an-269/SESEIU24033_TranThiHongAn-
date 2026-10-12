import SwiftUI

struct CartView: View {
    let cartItems: [CartItem]

    private var total: Double {
        cartItems.reduce(0) { $0 + $1.totalPrice }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cart")
                .font(.title3.bold())

            if cartItems.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "cart")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)

                    Text("Your cart is empty")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                ForEach(cartItems) { item in
                    HStack {
                        productImage(for: item.product.imageName)
                            .scaledToFill()
                            .frame(width: 36, height: 36)
                            .clipShape(RoundedRectangle(cornerRadius: 6))

                        VStack(alignment: .leading) {
                            Text(item.product.name)
                                .font(.subheadline.bold())
                            Text("Quantity: \(item.quantity)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text(formatPrice(item.totalPrice))
                            .font(.subheadline.bold())
                    }
                }

                Divider()

                HStack {
                    Text("Total")
                        .font(.headline)
                    Spacer()
                    Text(formatPrice(total))
                        .font(.headline)
                        .foregroundStyle(.red)
                }
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    // Hàm kiểm tra để tự động xử lý SF Symbol và ảnh thật từ Assets
    @ViewBuilder
    private func productImage(for name: String) -> some View {
        if name.contains(".fill") || name == "water.waves" {
            Image(systemName: name)
                .renderingMode(.template)
                .foregroundStyle(.blue)
        } else {
            Image(name)
                .renderingMode(.original)
        }
    }

    private func formatPrice(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "VND"
        formatter.currencySymbol = "₫"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))₫"
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        let categories = ProductCategory.samples
        let products = Product.samples(categories: categories)
        CartView(cartItems: CartItem.samples(products: products))
    }
}
