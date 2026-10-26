import Foundation

/// Errors raised when an order receives invalid input.
enum DeliveryOrderValidationError: LocalizedError {
    case emptyOrderID
    case emptyCustomerName
    case emptyDeliveryAddress
    case nonPositiveOrderValue

    var errorDescription: String? {
        switch self {
        case .emptyOrderID:
            return "Order ID cannot be empty."
        case .emptyCustomerName:
            return "Customer name cannot be empty."
        case .emptyDeliveryAddress:
            return "Delivery address cannot be empty."
        case .nonPositiveOrderValue:
            return "Order value must be greater than zero."
        }
    }
}

/// Abstract base type for all delivery order services.
///
/// Swift does not have a native `abstract` keyword. This class models an
/// abstract type by failing fast when one of its service-specific methods is
/// called directly. Every concrete delivery service must override those methods.
class DeliveryOrder {
    private(set) var orderID: String
    private(set) var customerName: String
    private(set) var deliveryAddress: String
    private(set) var orderValue: Decimal

    init(
        orderID: String,
        customerName: String,
        deliveryAddress: String,
        orderValue: Decimal
    ) throws {
        self.orderID = try Self.validatedOrderID(orderID)
        self.customerName = try Self.validatedCustomerName(customerName)
        self.deliveryAddress = try Self.validatedDeliveryAddress(deliveryAddress)
        self.orderValue = try Self.validatedOrderValue(orderValue)
    }

    /// Changes the order identifier after validating and normalizing it.
    func updateOrderID(to newOrderID: String) throws {
        orderID = try Self.validatedOrderID(newOrderID)
    }

    /// Changes both customer-facing fields as one validated operation.
    func updateCustomerInfo(name: String, deliveryAddress: String) throws {
        let validatedName = try Self.validatedCustomerName(name)
        let validatedAddress = try Self.validatedDeliveryAddress(deliveryAddress)
        customerName = validatedName
        self.deliveryAddress = validatedAddress
    }

    /// Changes the merchandise value for an order.
    func updateOrderValue(to newOrderValue: Decimal) throws {
        orderValue = try Self.validatedOrderValue(newOrderValue)
    }

    /// Returns the fee charged by this delivery service.
    func calculateDeliveryFee() -> Decimal {
        preconditionFailure("DeliveryOrder is abstract. Use a concrete delivery order type.")
    }

    /// Returns the delivery estimate associated with this service.
    func getEstimatedDeliveryTime() -> String {
        preconditionFailure("DeliveryOrder is abstract. Use a concrete delivery order type.")
    }

    /// Returns the customer-visible name of this service.
    func getServiceName() -> String {
        preconditionFailure("DeliveryOrder is abstract. Use a concrete delivery order type.")
    }

    private static func validatedOrderID(_ value: String) throws -> String {
        let normalizedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedValue.isEmpty else {
            throw DeliveryOrderValidationError.emptyOrderID
        }
        return normalizedValue
    }

    private static func validatedCustomerName(_ value: String) throws -> String {
        let normalizedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedValue.isEmpty else {
            throw DeliveryOrderValidationError.emptyCustomerName
        }
        return normalizedValue
    }

    private static func validatedDeliveryAddress(_ value: String) throws -> String {
        let normalizedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedValue.isEmpty else {
            throw DeliveryOrderValidationError.emptyDeliveryAddress
        }
        return normalizedValue
    }

    private static func validatedOrderValue(_ value: Decimal) throws -> Decimal {
        guard value > .zero else {
            throw DeliveryOrderValidationError.nonPositiveOrderValue
        }
        return value
    }
}
