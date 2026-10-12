import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedTab = 0
    @State private var products: [Product] = []
    @State private var cartItems: [CartItem] = []
    @State private var orders: [Order] = []

    private let categories = ProductCategory.samples

    private var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        }

        return products.filter {
            $0.name.lowercased().contains(searchText.lowercased())
            || $0.description.lowercased().contains(searchText.lowercased())
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            homeTab
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            categoryTab
                .tabItem {
                    Label("Categories", systemImage: "square.grid.2x2")
                }
                .tag(1)

            favoritesTab
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(2)

            orderTab
                .tabItem {
                    Label("Orders", systemImage: "list.clipboard")
                }
                .tag(3)

            accountTab
                .tabItem {
                    Label("Account", systemImage: "person")
                }
                .tag(4)
        }
        .tint(.blue)
        .onAppear(perform: loadSampleData)
    }

    private var homeTab: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    HomeHeaderView(
                        storeName: "The Aqua Realm",
                        subtitle: "Your ultimate underwater plug."
                    )

                    locationRow

                    SearchBarView(searchText: $searchText)

                    BannerView()

                    CategoryRowView(categories: categories)

                    productSection(
                        title: searchText.isEmpty ? "Featured Products" : "Search Results",
                        products: filteredProducts
                    )
                }
                .padding(.bottom, 24)
            }
            .background(
                LinearGradient(
                    colors: [.cyan.opacity(0.18), .white, .blue.opacity(0.08)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var categoryTab: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    CategoryRowView(categories: categories)
                    productSection(title: "All Products", products: products)
                }
                .padding(.top)
            }
            .navigationTitle("Categories")
            .background(Color(.systemGroupedBackground))
        }
    }

    private var favoritesTab: some View {
        NavigationStack {
            ScrollView {
                productSection(title: "Favorite Products", products: Array(products.prefix(3)))
                    .padding(.top)
            }
            .navigationTitle("Favorites")
            .background(Color(.systemGroupedBackground))
        }
    }

    private var orderTab: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    CartView(cartItems: cartItems)
                    OrderView(orders: orders)
                }
                .padding(.vertical)
            }
            .navigationTitle("Orders")
            .background(Color(.systemGroupedBackground))
        }
    }

    private var accountTab: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    profileCard
                    MapView()
                }
                .padding(.vertical)
            }
            .navigationTitle("Account")
            .background(Color(.systemGroupedBackground))
        }
    }

    private var locationRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.circle.fill")
                .font(.title2)
                .foregroundStyle(.blue)

            Text("Deliver to:")
                .font(.subheadline)

            Text("Enter your address?")
                .font(.subheadline.bold())
                .lineLimit(1)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.blue)
        }
        .padding()
        .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private var profileCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            Text("Grace Tran")
                .font(.title3.bold())

            Text("Track orders, manage delivery addresses, and get aquarium care consulting.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private func productSection(title: String, products: [Product]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)

                Spacer()

                Button("See all") {}
                    .font(.subheadline.bold())
            }
            .padding(.horizontal)

            if products.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)

                    Text("No products found")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(products) { product in
                            ProductCardView(product: product)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }
        }
    }

    private func loadSampleData() {
        guard products.isEmpty else { return }

        products = Product.samples(categories: categories)
        cartItems = CartItem.samples(products: products)
        orders = Order.samples(products: products)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
