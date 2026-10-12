import SwiftUI

struct ProductCardView: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(.cyan.opacity(0.12))
                    .frame(height: 92)
                    .overlay {
                        Image(systemName: product.imageName)
                            .font(.system(size: 44))
                            .foregroundStyle(.blue)
                    }

                Image(systemName: "heart")
                    .font(.caption.bold())
                    .padding(7)
                    .background(.white, in: Circle())
                    .padding(6)
            }

            Text(product.name)
                .font(.subheadline.bold())
                .lineLimit(1)

            Text(priceText)
                .font(.subheadline.bold())
                .foregroundStyle(.red)

            Text("Còn \(product.stock) sản phẩm")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .frame(width: 140)
        .background(.white, in: RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.08), radius: 5, y: 2)
    }

    private var priceText: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let text = formatter.string(from: NSNumber(value: product.price)) ?? "\(Int(product.price))"
        return "\(text)đ"
    }
}

struct ProductCardView_Previews: PreviewProvider {
    static var previews: some View {
        let categories = ProductCategory.samples
        ProductCardView(product: Product.samples(categories: categories)[0])
            .padding()
    }
}
