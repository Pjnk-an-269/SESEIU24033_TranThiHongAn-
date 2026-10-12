import Foundation

struct ProductCategory: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var subtitle: String
    var iconName: String
}

extension ProductCategory {
    static let samples: [ProductCategory] = [
        ProductCategory(name: "Ornamental Fish", subtitle: "Freshwater fish", iconName: "fish.fill"),
        ProductCategory(name: "Aquatic Plants", subtitle: "Foreground plants", iconName: "leaf.fill"),
        ProductCategory(name: "Tank Accessories", subtitle: "Rocks, driftwood, substrate", iconName: "shippingbox.fill"),
        ProductCategory(name: "Aquariums", subtitle: "Aquascape tanks", iconName: "water.waves"),
        ProductCategory(name: "Filter Equipment", subtitle: "Filters, air pumps", iconName: "gearshape.fill"),
        ProductCategory(name: "Fish Food", subtitle: "Pet food", iconName: "takeoutbag.and.cup.and.straw.fill"),
        ProductCategory(name: "Treatment & Care", subtitle: "Nutrients", iconName: "cross.case.fill"),
        ProductCategory(name: "Aquarium Shrimp", subtitle: "Ornamental shrimp", iconName: "circle.grid.2x2.fill"),
        ProductCategory(name: "Promotions", subtitle: "Today's deals", iconName: "tag.fill"),
        ProductCategory(name: "Consulting", subtitle: "Q&A", iconName: "message.fill")
    ]
}
