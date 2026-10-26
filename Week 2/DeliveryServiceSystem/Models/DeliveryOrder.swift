import Foundation

/// The common contract for every delivery service order.
///
/// Swift does not have a native `abstract` keyword. This class models an
/// abstract base type by making its service-specific methods fail immediately;
/// applications should instantiate one of its concrete subclasses instead.
class DeliveryOrder {
    private(set) var orderID: String
    private(set) var customerName: String
    private(set) var deliveryAddress: String
    private(set) var orderValue: Double

    /// Creates an order only when all shared data is valid.
    init?(
        orderID: String,
        customerName: String,
        deliveryAddress: String,
        orderValue: Double
    ) {
        let normalizedOrderID = Self.normalizedNonEmptyString(orderID)
        let normalizedCustomerName = Self.normalizedNonEmptyString(customerName)
        let normalizedDeliveryAddress = Self.normalizedNonEmptyString(deliveryAddress)

        guard
            let normalizedOrderID,
            let normalizedCustomerName,
            let normalizedDeliveryAddress,
            orderValue.isFinite,
            orderValue > 0
        else {
            return nil
        }

        self.orderID = normalizedOrderID
        self.customerName = normalizedCustomerName
        self.deliveryAddress = normalizedDeliveryAddress
        self.orderValue = orderValue
    }

    /// Updates customer data atomically. Invalid input leaves the order unchanged.
    @discardableResult
    func updateCustomerInfo(customerName: String, deliveryAddress: String) -> Bool {
        guard
            let normalizedCustomerName = Self.normalizedNonEmptyString(customerName),
            let normalizedDeliveryAddress = Self.normalizedNonEmptyString(deliveryAddress)
        else {
            return false
        }

        self.customerName = normalizedCustomerName
        self.deliveryAddress = normalizedDeliveryAddress
        return true
    }

    /// Updates the merchandise value. The value must be a finite positive number.
    @discardableResult
    func updateOrderValue(_ newOrderValue: Double) -> Bool {
        guard newOrderValue.isFinite, newOrderValue > 0 else {
            return false
        }

        orderValue = newOrderValue
        return true
    }

    /// Returns the fixed or computed delivery fee for this service.
    func calculateDeliveryFee() -> Double {
        fatalError("DeliveryOrder is abstract. Use a concrete delivery order type.")
    }

    /// Returns the promised delivery timeframe for this service.
    func getEstimatedDeliveryTime() -> String {
        fatalError("DeliveryOrder is abstract. Use a concrete delivery order type.")
    }

    /// Returns the user-facing service category name.
    func getServiceName() -> String {
        fatalError("DeliveryOrder is abstract. Use a concrete delivery order type.")
    }

    private static func normalizedNonEmptyString(_ value: String) -> String? {
        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return normalized.isEmpty ? nil : normalized
    }
}
