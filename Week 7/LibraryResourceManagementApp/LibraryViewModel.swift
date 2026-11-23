import Combine
import Foundation

@MainActor
public final class LibraryViewModel: ObservableObject {
    @Published public var searchText: String = ""
    @Published public private(set) var resources: [LibraryResource] = []

    private let libraryManager = LibraryManager()

    public init() {
        do {
            let sampleResources = try Self.makeSampleResources()
            for resource in sampleResources {
                try libraryManager.addResource(resource)
            }
            resources = sampleResources
        } catch {
            assertionFailure("Unable to create the library sample data: \(error.localizedDescription)")
            resources = []
        }
    }

    public var filteredResources: [LibraryResource] {
        libraryManager.searchResources(matching: searchText)
    }

    public func requestAccess(to resource: LibraryResource, mode: AccessMode) throws {
        try libraryManager.requestAccess(to: resource, mode: mode)
    }

    public func calculateFee(
        for resource: LibraryResource,
        durationDays: Int,
        mode: AccessMode
    ) throws -> Decimal {
        try libraryManager.calculateFee(for: resource, durationDays: durationDays, mode: mode)
    }

    public func endAccess(to resource: LibraryResource) throws {
        try libraryManager.endAccess(to: resource)
    }

    private static func makeSampleResources() throws -> [LibraryResource] {
        let now = Date()
        let standardBook = try PrintedBook(
            resourceID: "BOOK-001",
            title: "Swift Programming: The Big Nerd Ranch Guide",
            publicationYear: 2023,
            author: "Matthew Mathias and John Gallagher",
            isbn: "978-0135264027",
            loanCategory: .standard,
            refundableDeposit: Decimal(string: "20.00")!,
            lateFeePerDay: Decimal(string: "1.00")!
        )
        let shortTermBook = try PrintedBook(
            resourceID: "BOOK-002",
            title: "iOS API Reference Handbook",
            publicationYear: 2024,
            author: "Library Editorial Team",
            isbn: "978-0139991005",
            loanCategory: .shortTerm,
            refundableDeposit: Decimal(string: "20.00")!,
            lateFeePerDay: Decimal(string: "1.00")!
        )
        let borrowedBook = try PrintedBook(
            resourceID: "BOOK-003",
            title: "Human-Computer Interaction: An Introduction",
            publicationYear: 2022,
            author: "Helen Sharp, Yvonne Rogers, and Jenny Preece",
            isbn: "978-1119901099",
            loanCategory: .standard,
            refundableDeposit: Decimal(string: "20.00")!,
            lateFeePerDay: Decimal(string: "1.00")!
        )
        let onsiteJournal = try AcademicJournal(
            resourceID: "JOURNAL-001",
            title: "Journal of Mobile Computing",
            publicationYear: 2025,
            volumeNumber: 18,
            issueNumber: 2,
            isLoanable: false,
            loanPeriodDays: 7,
            refundableDeposit: .zero,
            lateFeePerDay: .zero,
            accessFee: Decimal(string: "0.50")!
        )
        let loanableJournal = try AcademicJournal(
            resourceID: "JOURNAL-002",
            title: "Applied Software Engineering Review",
            publicationYear: 2024,
            volumeNumber: 12,
            issueNumber: 4,
            isLoanable: true,
            loanPeriodDays: 7,
            refundableDeposit: Decimal(string: "10.00")!,
            lateFeePerDay: Decimal(string: "1.50")!,
            accessFee: Decimal(string: "0.50")!
        )
        let availableDigitalMaterial = try DigitalMaterial(
            resourceID: "DIGITAL-001",
            title: "ACM Digital Library Collection",
            publicationYear: 2026,
            provider: "ACM Digital Library",
            licenseExpiresAt: now.addingTimeInterval(60 * 60 * 24 * 30),
            maxConcurrentUsers: 3,
            accessFeePerDay: Decimal(string: "0.50")!
        )
        let fullDigitalMaterial = try DigitalMaterial(
            resourceID: "DIGITAL-002",
            title: "IEEE Xplore Research Archive",
            publicationYear: 2026,
            provider: "IEEE Xplore",
            licenseExpiresAt: now.addingTimeInterval(60 * 60 * 24 * 60),
            maxConcurrentUsers: 2,
            accessFeePerDay: Decimal(string: "0.50")!
        )
        let expiredDigitalMaterial = try DigitalMaterial(
            resourceID: "DIGITAL-003",
            title: "Digital Thesis Repository",
            publicationYear: 2021,
            provider: "University Repository",
            licenseExpiresAt: now.addingTimeInterval(-60 * 60 * 24),
            maxConcurrentUsers: 5,
            accessFeePerDay: Decimal(string: "0.50")!
        )

        try borrowedBook.beginAccess(on: now, mode: .loan)
        try availableDigitalMaterial.beginAccess(on: now, mode: .digital)
        try fullDigitalMaterial.beginAccess(on: now, mode: .digital)
        try fullDigitalMaterial.beginAccess(on: now, mode: .digital)

        return [
            standardBook,
            shortTermBook,
            borrowedBook,
            onsiteJournal,
            loanableJournal,
            availableDigitalMaterial,
            fullDigitalMaterial,
            expiredDigitalMaterial
        ]
    }
}
