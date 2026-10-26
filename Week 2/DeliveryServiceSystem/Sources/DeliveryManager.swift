import Foundation

/// Owns and performs array-based operations on delivery orders.
///
/// It depends only on `DeliveryOrder` polymorphism. Therefore, a new concrete
/// service can be introduced without changing manager logic (Open-Closed Principle).
final class DeliveryManager {
    private(set) var orders: [DeliveryOrder] = []

    /// Adds an order when its identifier is not already present.
    /// - Returns: `true` when the order was appended; `false` for duplicate IDs.
    @discardableResult
    func addOrder(_ order: DeliveryOrder) -> Bool {
        guard findOrderByID(order.orderID) == nil else {
            return false
        }

        orders.append(order)
        return true
    }

    /// Finds the first order with an exact identifier using a linear search.
    func findOrderByID(_ id: String) -> DeliveryOrder? {
        let normalizedID = id.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedID.isEmpty else {
            return nil
        }

        return orders.first { $0.orderID == normalizedID }
    }

    /// Returns all orders in the named service category, case-insensitively.
    func filterOrders(byServiceName name: String) -> [DeliveryOrder] {
        let normalizedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedName.isEmpty else {
            return []
        }

        return orders.filter {
            $0.getServiceName().caseInsensitiveCompare(normalizedName) == .orderedSame
        }
    }

    /// Sorts the manager's order array by merchandise value.
    func sortOrdersByValue(ascending: Bool) {
        orders.sort {
            if $0.orderValue == $1.orderValue {
                return $0.orderID.localizedStandardCompare($1.orderID) == .orderedAscending
            }

            return ascending ? $0.orderValue < $1.orderValue : $0.orderValue > $1.orderValue
        }
    }

    /// Aggregates delivery fees across all stored orders.
    func calculateTotalDeliveryFees() -> Double {
        orders.reduce(0) { partialTotal, order in
            partialTotal + order.calculateDeliveryFee()
        }
    }

    /// Aggregates delivery fees for one named service category.
    func calculateTotalFee(forServiceName name: String) -> Double {
        filterOrders(byServiceName: name).reduce(0) { partialTotal, order in
            partialTotal + order.calculateDeliveryFee()
        }
    }
}
