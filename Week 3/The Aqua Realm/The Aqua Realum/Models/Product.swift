import Foundation

struct Product: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var categoryID: UUID
    var price: Double
    var imageName: String
    var description: String
    var stock: Int
}

extension Product {
    static func samples(categories: [ProductCategory]) -> [Product] {
        func idForCategory(_ name: String) -> UUID {
            categories.first { $0.name == name }?.id ?? categories[0].id
        }

        return [
            Product(
                name: "Neon Tetra Fish",
                categoryID: idForCategory("Ornamental Fish"),
                price: 20000,
                imageName: "neon", 
                description: "Small, easy to care for, school-swimming fish.",
                stock: 30
            ),
            Product(
                name: "Java Fern Plant",
                categoryID: idForCategory("Aquatic Plants"),
                price: 50000,
                imageName: "leaf.fill",
                description: "Hardy aquatic plant, perfect for beginners.",
                stock: 18
            ),
            Product(
                name: "Water Filter",
                categoryID: idForCategory("Filter Equipment"),
                price: 350000,
                imageName: "gearshape.fill",
                description: "Water filtration for mini and medium aquariums.",
                stock: 12
            ),
            Product(
                name: "Mini Glass Aquarium",
                categoryID: idForCategory("Aquariums"),
                price: 250000,
                imageName: "water.waves",
                description: "Compact glass tank perfect for study desks.",
                stock: 8
            ),
            Product(
                name: "Fish Food",
                categoryID: idForCategory("Fish Food"),
                price: 45000,
                imageName: "takeoutbag.and.cup.and.straw.fill",
                description: "Premium pellet food for ornamental fish.",
                stock: 40
            )
        ]
    }
}
