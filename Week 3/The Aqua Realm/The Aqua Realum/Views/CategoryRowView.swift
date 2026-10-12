import SwiftUI

struct CategoryRowView: View {
    let categories: [ProductCategory]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(categories) { category in
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(.blue.opacity(0.08))
                        .frame(height: 64)
                        .overlay {
                            Image(systemName: category.iconName)
                                .font(.title)
                                .foregroundStyle(.blue)
                        }

                    Text(category.name)
                        .font(.caption.bold())
                        .multilineTextAlignment(.center)
                        .lineLimit(2)

                    Text(category.subtitle)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct CategoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRowView(categories: ProductCategory.samples)
    }
}
