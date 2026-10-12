import Foundation

enum OrderStatus: String, CaseIterable, Identifiable {
    case pending = "Pending"
    case preparing = "Preparing"
    case shipping = "Shipping"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
    
    var id: String { rawValue }
}
