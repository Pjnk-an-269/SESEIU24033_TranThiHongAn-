import SwiftUI

public struct ContentView: View {
    @StateObject private var viewModel = LibraryViewModel()

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.filteredResources) { resource in
                        NavigationLink {
                            ResourceDetailView(resource: resource, viewModel: viewModel)
                        } label: {
                            ResourceRow(resource: resource)
                        }
                    }
                } header: {
                    Text("Library collection")
                } footer: {
                    Text("Select an item to review its details, availability, and estimated fees.")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Library Resources")
            .searchable(text: $viewModel.searchText, prompt: "Search title, author, ID, or provider")
            .overlay {
                if viewModel.filteredResources.isEmpty {
                    ContentUnavailableView.search(text: viewModel.searchText)
                }
            }
        }
    }
}

private struct ResourceRow: View {
    @ObservedObject var resource: LibraryResource

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundStyle(.tint)
                .frame(width: 32)
                .padding(.top, 3)

            VStack(alignment: .leading, spacing: 6) {
                Text(resource.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("\(resource.resourceType) · \(resource.publicationYear)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(resource.resourceID)
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
                StatusBadge(resource: resource)
            }
            Spacer(minLength: 4)
        }
        .padding(.vertical, 5)
    }

    private var iconName: String {
        if resource is PrintedBook { return "book.closed" }
        if resource is AcademicJournal { return "text.book.closed" }
        return "doc.text.magnifyingglass"
    }
}

private struct StatusBadge: View {
    @ObservedObject var resource: LibraryResource

    var body: some View {
        Text(statusText)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .foregroundStyle(statusColor)
            .background(statusColor.opacity(0.13), in: Capsule())
            .accessibilityLabel("Status: \(statusText)")
    }

    private var statusText: String {
        if let digitalMaterial = resource as? DigitalMaterial, digitalMaterial.isExpired {
            return "Expired"
        }
        if let journal = resource as? AcademicJournal, !journal.isLoanable {
            return "In-Library Only"
        }
        if resource is DigitalMaterial {
            if !resource.isAvailable { return "Full" }
            if resource.activeAccessCount > 0 {
                return "\(resource.remainingAccessSlots) slot\(resource.remainingAccessSlots == 1 ? "" : "s") left"
            }
            return "Available"
        }
        return resource.isAvailable ? "Available" : "Borrowed"
    }

    private var statusColor: Color {
        switch statusText {
        case "Expired", "Full": return .red
        case "In-Library Only": return .orange
        case "Borrowed": return .purple
        case "Available": return .green
        default: return .blue
        }
    }
}

