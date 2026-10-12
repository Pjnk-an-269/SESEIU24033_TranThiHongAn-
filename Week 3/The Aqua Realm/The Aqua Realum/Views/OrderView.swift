import SwiftUI

struct OrderView: View {
    let orders: [Order]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Orders")
                .font(.title3.bold())

            if orders.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "list.clipboard")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)

                    Text("No orders available")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                ForEach(orders) { order in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(order.customerName)
                                .font(.headline)

                            Spacer()

                            Text(order.status.rawValue)
                                .font(.caption.bold())
                                .foregroundStyle(.blue)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(.blue.opacity(0.1), in: Capsule())
                        }

                        Text("Items: \(order.items.count)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("Total Price: \(formatPrice(order.totalPrice))")
                            .font(.subheadline.bold())
                            .foregroundStyle(.red)
                    }
                    .padding()
                    .background(.white, in: RoundedRectangle(cornerRadius: 14))
                }
            }
        }
        .padding(.horizontal)
    }

    private func formatPrice(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let text = formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
        return "\(text)đ"
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        let categories = ProductCategory.samples
        let products = Product.samples(categories: categories)
        OrderView(orders: Order.samples(products: products))
    }
}
