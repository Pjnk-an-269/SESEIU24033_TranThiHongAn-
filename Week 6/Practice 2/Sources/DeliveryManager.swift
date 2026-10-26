import Foundation

/// A consolidated, immutable snapshot of performance for a delivery service.
struct DeliveryServiceStatistics {
    let serviceName: String
    let orderCount: Int
    let totalOrderValue: Decimal
    let totalDeliveryFees: Decimal
}

enum DeliveryManagerError: LocalizedError {
    case duplicateOrderID(String)

    var errorDescription: String? {
        switch self {
        case .duplicateOrderID(let orderID):
            return "An order with ID '\(orderID)' already exists."
        }
    }
}

/// Owns the order collection and calculates delivery-service metrics.
///
/// The manager works only with `DeliveryOrder`, so new delivery services can be
/// introduced as subclasses without changing any order-processing logic here.
final class DeliveryManager {
    private(set) var orders: [DeliveryOrder] = []

    func addOrder(_ order: DeliveryOrder) throws {
        guard self.order(withID: order.orderID) == nil else {
            throw DeliveryManagerError.duplicateOrderID(order.orderID)
        }
        orders.append(order)
    }

    @discardableResult
    func removeOrder(withID orderID: String) -> Bool {
        guard let index = orders.firstIndex(where: { $0.orderID == orderID }) else {
            return false
        }
        orders.remove(at: index)
        return true
    }

    func order(withID orderID: String) -> DeliveryOrder? {
        orders.first { $0.orderID == orderID }
    }

    func orders(forServiceNamed serviceName: String) -> [DeliveryOrder] {
        orders.filter { $0.getServiceName() == serviceName }
    }

    func totalOrderValue() -> Decimal {
        orders.reduce(.zero) { $0 + $1.orderValue }
    }

    func totalDeliveryFees() -> Decimal {
        orders.reduce(.zero) { $0 + $1.calculateDeliveryFee() }
    }

    /// Returns merchandise-value revenue grouped by concrete delivery service.
    func orderValueRevenueByService() -> [String: Decimal] {
        statisticsByService().reduce(into: [:]) { revenue, statistic in
            revenue[statistic.serviceName] = statistic.totalOrderValue
        }
    }

    /// Returns delivery-fee revenue grouped by concrete delivery service.
    func deliveryFeeRevenueByService() -> [String: Decimal] {
        statisticsByService().reduce(into: [:]) { revenue, statistic in
            revenue[statistic.serviceName] = statistic.totalDeliveryFees
        }
    }

    /// Calculates all per-service metrics in one polymorphic pass over the orders.
    func statisticsByService() -> [DeliveryServiceStatistics] {
        var statistics: [String: DeliveryServiceStatistics] = [:]

        for order in orders {
            let serviceName = order.getServiceName()
            let existing = statistics[serviceName]
            statistics[serviceName] = DeliveryServiceStatistics(
                serviceName: serviceName,
                orderCount: (existing?.orderCount ?? 0) + 1,
                totalOrderValue: (existing?.totalOrderValue ?? .zero) + order.orderValue,
                totalDeliveryFees: (existing?.totalDeliveryFees ?? .zero) + order.calculateDeliveryFee()
            )
        }

        return statistics.values.sorted {
            $0.serviceName.localizedCaseInsensitiveCompare($1.serviceName) == .orderedAscending
        }
    }
}
