import Combine
import Foundation

public enum AccessMode: String, CaseIterable, Identifiable {
    case loan
    case onsite
    case digital

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .loan: return "Loan"
        case .onsite: return "In-library use"
        case .digital: return "Online access"
        }
    }
}

public enum BookLoanCategory: String, CaseIterable, Identifiable {
    case standard
    case shortTerm

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .shortTerm: return "Short-term / reference"
        }
    }

    public var loanPeriodDays: Int {
        switch self {
        case .standard: return 14
        case .shortTerm: return 3
        }
    }
}

public enum LibraryResourceError: Error, LocalizedError {
    case invalidDuration
    case unsupportedAccessMode
    case accessUnavailable
    case noActiveAccess
    case resourceNotFound
    case duplicateResourceID
    case invalidConcurrencyLimit
    case invalidFee
    case invalidMetadata

    public var errorDescription: String? {
        switch self {
        case .invalidDuration:
            return "The duration must be a positive whole number of days."
        case .unsupportedAccessMode:
            return "This resource does not support the selected access mode. This journal is available for in-library use only."
        case .accessUnavailable:
            return "Access is unavailable. The resource may already be borrowed, its digital license may have expired, or all licensed user slots may be occupied."
        case .noActiveAccess:
            return "There is no active loan or access session to end for this resource."
        case .resourceNotFound:
            return "The requested resource is not registered with this library."
        case .duplicateResourceID:
            return "A resource with this ID is already registered. Resource IDs must be unique."
        case .invalidConcurrencyLimit:
            return "The maximum number of concurrent users must be at least one."
        case .invalidFee:
            return "Fees cannot be negative. Enter a zero or positive fee amount."
        case .invalidMetadata:
            return "Required resource information is missing or invalid. Check the ID, title, publication year, and type-specific details."
        }
    }
}

public protocol AccessControlling: AnyObject {
    func canRequestAccess(on date: Date, mode: AccessMode) -> Bool
    func beginAccess(on date: Date, mode: AccessMode) throws
    func endAccess() throws
}

public protocol FeeCalculating: AnyObject {
    func calculateFee(for durationDays: Int, mode: AccessMode) throws -> Decimal
}

open class LibraryResource: ObservableObject, Identifiable, AccessControlling, FeeCalculating {
    public let resourceID: String
    public let title: String
    public let publicationYear: Int
    public let maxConcurrentUsers: Int
    @Published public private(set) var activeAccessCount: Int = 0

    public var id: String { resourceID }

    public var isAvailable: Bool {
        remainingAccessSlots > 0
    }

    public var remainingAccessSlots: Int {
        max(0, maxConcurrentUsers - activeAccessCount)
    }

    open var resourceType: String {
        "Library resource"
    }

    open var searchableText: String {
        "\(resourceID) \(title) \(publicationYear) \(resourceType)"
    }

    public init(
        resourceID: String,
        title: String,
        publicationYear: Int,
        maxConcurrentUsers: Int = 1
    ) throws {
        guard !resourceID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              publicationYear > 0 else {
            throw LibraryResourceError.invalidMetadata
        }
        guard maxConcurrentUsers >= 1 else {
            throw LibraryResourceError.invalidConcurrencyLimit
        }

        self.resourceID = resourceID
        self.title = title
        self.publicationYear = publicationYear
        self.maxConcurrentUsers = maxConcurrentUsers
    }

    open func canRequestAccess(on date: Date, mode: AccessMode) -> Bool {
        remainingAccessSlots > 0
    }

    open func calculateFee(for durationDays: Int, mode: AccessMode) throws -> Decimal {
        guard durationDays > 0 else {
            throw LibraryResourceError.invalidDuration
        }
        throw LibraryResourceError.unsupportedAccessMode
    }

    public func beginAccess(on date: Date, mode: AccessMode) throws {
        _ = try calculateFee(for: 1, mode: mode)
        guard canRequestAccess(on: date, mode: mode) else {
            throw LibraryResourceError.accessUnavailable
        }
        activeAccessCount += 1
    }

    public func endAccess() throws {
        guard activeAccessCount > 0 else {
            throw LibraryResourceError.noActiveAccess
        }
        activeAccessCount -= 1
    }
}

public final class PrintedBook: LibraryResource {
    public let author: String
    public let isbn: String
    public let loanCategory: BookLoanCategory
    public let refundableDeposit: Decimal
    public let lateFeePerDay: Decimal

    public var loanPeriodDays: Int {
        loanCategory.loanPeriodDays
    }

    public override var resourceType: String {
        "Printed book"
    }

    public override var searchableText: String {
        "\(super.searchableText) \(author) \(isbn) \(loanCategory.displayName)"
    }

    public init(
        resourceID: String,
        title: String,
        publicationYear: Int,
        author: String,
        isbn: String,
        loanCategory: BookLoanCategory,
        refundableDeposit: Decimal,
        lateFeePerDay: Decimal
    ) throws {
        guard !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !isbn.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw LibraryResourceError.invalidMetadata
        }
        guard refundableDeposit >= .zero, lateFeePerDay >= .zero else {
            throw LibraryResourceError.invalidFee
        }

        self.author = author
        self.isbn = isbn
        self.loanCategory = loanCategory
        self.refundableDeposit = refundableDeposit
        self.lateFeePerDay = lateFeePerDay
        try super.init(
            resourceID: resourceID,
            title: title,
            publicationYear: publicationYear,
            maxConcurrentUsers: 1
        )
    }

    public override func canRequestAccess(on date: Date, mode: AccessMode) -> Bool {
        mode == .loan && super.canRequestAccess(on: date, mode: mode)
    }

    public override func calculateFee(for durationDays: Int, mode: AccessMode) throws -> Decimal {
        guard durationDays > 0 else {
            throw LibraryResourceError.invalidDuration
        }
        guard mode == .loan else {
            throw LibraryResourceError.unsupportedAccessMode
        }

        let overdueDays = max(0, durationDays - loanPeriodDays)
        return refundableDeposit + lateFeePerDay * Decimal(overdueDays)
    }
}

public final class AcademicJournal: LibraryResource {
    public let volumeNumber: Int
    public let issueNumber: Int
    public let isLoanable: Bool
    public let loanPeriodDays: Int
    public let refundableDeposit: Decimal
    public let lateFeePerDay: Decimal
    public let accessFee: Decimal

    public override var resourceType: String {
        "Academic journal"
    }

    public override var searchableText: String {
        "\(super.searchableText) volume \(volumeNumber) issue \(issueNumber) \(isLoanable ? "loanable" : "in-library only")"
    }

    public init(
        resourceID: String,
        title: String,
        publicationYear: Int,
        volumeNumber: Int,
        issueNumber: Int,
        isLoanable: Bool,
        loanPeriodDays: Int,
        refundableDeposit: Decimal,
        lateFeePerDay: Decimal,
        accessFee: Decimal
    ) throws {
        guard volumeNumber > 0, issueNumber > 0, loanPeriodDays > 0 else {
            throw LibraryResourceError.invalidMetadata
        }
        guard refundableDeposit >= .zero, lateFeePerDay >= .zero, accessFee >= .zero else {
            throw LibraryResourceError.invalidFee
        }

        self.volumeNumber = volumeNumber
        self.issueNumber = issueNumber
        self.isLoanable = isLoanable
        self.loanPeriodDays = loanPeriodDays
        self.refundableDeposit = refundableDeposit
        self.lateFeePerDay = lateFeePerDay
        self.accessFee = accessFee
        try super.init(
            resourceID: resourceID,
            title: title,
            publicationYear: publicationYear,
            maxConcurrentUsers: 1
        )
    }

    public override func canRequestAccess(on date: Date, mode: AccessMode) -> Bool {
        switch mode {
        case .onsite:
            return super.canRequestAccess(on: date, mode: mode)
        case .loan:
            return isLoanable && super.canRequestAccess(on: date, mode: mode)
        case .digital:
            return false
        }
    }

    public override func calculateFee(for durationDays: Int, mode: AccessMode) throws -> Decimal {
        guard durationDays > 0 else {
            throw LibraryResourceError.invalidDuration
        }

        switch mode {
        case .onsite:
            return accessFee
        case .loan:
            guard isLoanable else {
                throw LibraryResourceError.unsupportedAccessMode
            }
            let overdueDays = max(0, durationDays - loanPeriodDays)
            return refundableDeposit + lateFeePerDay * Decimal(overdueDays)
        case .digital:
            throw LibraryResourceError.unsupportedAccessMode
        }
    }
}

public final class DigitalMaterial: LibraryResource {
    public let provider: String
    public let licenseExpiresAt: Date
    public let accessFeePerDay: Decimal

    public var isExpired: Bool {
        licenseExpiresAt <= Date()
    }

    public override var resourceType: String {
        "Digital material"
    }

    public override var searchableText: String {
        "\(super.searchableText) \(provider) \(licenseExpiresAt.formatted(date: .abbreviated, time: .omitted))"
    }

    public init(
        resourceID: String,
        title: String,
        publicationYear: Int,
        provider: String,
        licenseExpiresAt: Date,
        maxConcurrentUsers: Int,
        accessFeePerDay: Decimal
    ) throws {
        guard !provider.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw LibraryResourceError.invalidMetadata
        }
        guard accessFeePerDay >= .zero else {
            throw LibraryResourceError.invalidFee
        }

        self.provider = provider
        self.licenseExpiresAt = licenseExpiresAt
        self.accessFeePerDay = accessFeePerDay
        try super.init(
            resourceID: resourceID,
            title: title,
            publicationYear: publicationYear,
            maxConcurrentUsers: maxConcurrentUsers
        )
    }

    public override func canRequestAccess(on date: Date, mode: AccessMode) -> Bool {
        mode == .digital && licenseExpiresAt > date && super.canRequestAccess(on: date, mode: mode)
    }

    public override func calculateFee(for durationDays: Int, mode: AccessMode) throws -> Decimal {
        guard durationDays > 0 else {
            throw LibraryResourceError.invalidDuration
        }
        guard mode == .digital else {
            throw LibraryResourceError.unsupportedAccessMode
        }
        return accessFeePerDay * Decimal(durationDays)
    }
}

public struct ResourceSummary: Identifiable {
    public let resourceID: String
    public let title: String
    public let publicationYear: Int
    public let resourceType: String
    public let activeAccessCount: Int
    public let maxConcurrentUsers: Int
    public let isAvailable: Bool
    public let remainingAccessSlots: Int

    public var id: String { resourceID }

    public init(resource: LibraryResource) {
        resourceID = resource.resourceID
        title = resource.title
        publicationYear = resource.publicationYear
        resourceType = resource.resourceType
        activeAccessCount = resource.activeAccessCount
        maxConcurrentUsers = resource.maxConcurrentUsers
        isAvailable = resource.isAvailable
        remainingAccessSlots = resource.remainingAccessSlots
    }
}
