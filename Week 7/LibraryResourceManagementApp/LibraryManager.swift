import Foundation

public final class LibraryManager {
    private var resourcesByID: [String: LibraryResource] = [:]

    public init() {}

    public func addResource(_ resource: LibraryResource) throws {
        guard resourcesByID[resource.resourceID] == nil else {
            throw LibraryResourceError.duplicateResourceID
        }
        resourcesByID[resource.resourceID] = resource
    }

    public func resource(withID resourceID: String) throws -> LibraryResource {
        guard let resource = resourcesByID[resourceID] else {
            throw LibraryResourceError.resourceNotFound
        }
        return resource
    }

    public func searchResources(matching query: String) -> [LibraryResource] {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let resources = resourcesByID.values.sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
        guard !normalizedQuery.isEmpty else {
            return resources
        }
        return resources.filter {
            $0.searchableText.localizedCaseInsensitiveContains(normalizedQuery)
        }
    }

    public func summaries(matching query: String = "") -> [ResourceSummary] {
        searchResources(matching: query).map(ResourceSummary.init(resource:))
    }

    public func requestAccess(
        to resource: LibraryResource,
        mode: AccessMode,
        on date: Date = Date()
    ) throws {
        try requireRegistered(resource)
        try resource.beginAccess(on: date, mode: mode)
    }

    public func calculateFee(
        for resource: LibraryResource,
        durationDays: Int,
        mode: AccessMode
    ) throws -> Decimal {
        try requireRegistered(resource)
        return try resource.calculateFee(for: durationDays, mode: mode)
    }

    public func endAccess(to resource: LibraryResource) throws {
        try requireRegistered(resource)
        try resource.endAccess()
    }

    private func requireRegistered(_ resource: LibraryResource) throws {
        guard let registeredResource = resourcesByID[resource.resourceID], registeredResource === resource else {
            throw LibraryResourceError.resourceNotFound
        }
    }
}
