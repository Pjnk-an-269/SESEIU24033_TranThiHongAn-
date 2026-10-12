import Foundation
import SwiftUI

class Fish: Identifiable {
    // MARK: - Properties (Private)
    private var _id: Int
    private var _name: String
    private var _color: String
    private var _price: Double
    
    var id: Int { return _id }
    
    // MARK: - Constructor
    init(id: Int, name: String, color: String, price: Double) {
        self._id = id
        self._name = name
        self._color = color
        self._price = price
    }
    
    // MARK: - Getters & Setters
    func getId() -> Int { return _id }
    func getName() -> String { return _name }
    func getColor() -> String { return _color }
    func getPrice() -> Double { return _price }
    
    func getInfo() -> String {
        return "[\(_id)] \(_name) - \(_color) - $\(_price)"
    }
    
    func setName(_ newName: String) { self._name = newName }
    func setColor(_ newColor: String) { self._color = newColor }
    func setPrice(_ newPrice: Double) { self._price = newPrice }
    
    // MARK: - UI Helper
    func getColorValue() -> Color {
        switch _color.lowercased() {
        case "red": return .red
        case "blue": return .blue
        case "orange": return .orange
        case "silver": return .gray
        case "gold": return .yellow
        case "green": return .green
        default: return .black
        }
    }
    
    func getImageName() -> String {
        let lowerName = _name.lowercased()
        
        if lowerName.contains("neon") { return "neon" }
        if lowerName.contains("betta") { return "betta" }
        if lowerName.contains("gold") { return "gold" }
        if lowerName.contains("angel") { return "angel" }
        
        // Fallback nếu người dùng nhập tên cá mới chưa có ảnh
        return "fish.fill"
    }
}
