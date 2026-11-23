import SwiftUI
import UIKit

public struct ResourceDetailView: View {
    @ObservedObject private var resource: LibraryResource
    @ObservedObject private var viewModel: LibraryViewModel
    @State private var durationDays = 14
    @State private var errorMessage: String?
    @State private var successMessage: String?

    public init(resource: LibraryResource, viewModel: LibraryViewModel) {
        self.resource = resource
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                titleSection
                commonDetailsSection
                specificDetailsSection
                feeSection
                actionSection
                if let successMessage {
                    Label(successMessage, systemImage: "checkmark.circle.fill")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.green)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.green.opacity(0.10), in: RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .navigationTitle("Resource Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Action Rejected", isPresented: errorAlertIsPresented) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "The requested action could not be completed.")
        }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(resource.title)
                .font(.largeTitle.bold())
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 8) {
                Text(resource.resourceType)
                Text("·")
                Text(resource.resourceID).font(.caption.monospaced())
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            StatusBadgeForDetail(resource: resource)
        }
    }

    private var commonDetailsSection: some View {
        DetailCard(title: "Resource information", systemImage: "info.circle") {
            DetailRow(title: "Publication year", value: String(resource.publicationYear))
            DetailRow(title: "Maximum concurrent users", value: String(resource.maxConcurrentUsers))
            DetailRow(title: "Active loans / sessions", value: String(resource.activeAccessCount))
            DetailRow(title: "Remaining access slots", value: String(resource.remainingAccessSlots))
            DetailRow(title: "Current availability", value: resource.isAvailable ? "Available" : "At capacity")
        }
    }

    @ViewBuilder
    private var specificDetailsSection: some View {
        if let book = resource as? PrintedBook {
            DetailCard(title: "Printed book details", systemImage: "book.closed") {
                DetailRow(title: "Author", value: book.author)
                DetailRow(title: "ISBN", value: book.isbn)
                DetailRow(title: "Loan category", value: book.loanCategory.displayName)
                DetailRow(title: "Standard loan period", value: "\(book.loanPeriodDays) days")
                DetailRow(title: "Late fee per day", value: feeText(book.lateFeePerDay))
            }
        } else if let journal = resource as? AcademicJournal {
            DetailCard(title: "Academic journal details", systemImage: "text.book.closed") {
                DetailRow(title: "Volume", value: String(journal.volumeNumber))
                DetailRow(title: "Issue", value: String(journal.issueNumber))
                DetailRow(title: "Loan policy", value: journal.isLoanable ? "Loanable" : "In-library only")
                if journal.isLoanable {
                    DetailRow(title: "Loan period", value: "\(journal.loanPeriodDays) days")
                    DetailRow(title: "Late fee per day", value: feeText(journal.lateFeePerDay))
                }
            }
        } else if let digitalMaterial = resource as? DigitalMaterial {
            DetailCard(title: "Digital material details", systemImage: "doc.text.magnifyingglass") {
                DetailRow(title: "Provider", value: digitalMaterial.provider)
                DetailRow(
                    title: "License expires",
                    value: digitalMaterial.licenseExpiresAt.formatted(date: .abbreviated, time: .omitted)
                )
                DetailRow(title: "License status", value: digitalMaterial.isExpired ? "Expired" : "Active")
                DetailRow(title: "Concurrent user limit", value: String(digitalMaterial.maxConcurrentUsers))
                DetailRow(title: "Daily access fee", value: feeText(digitalMaterial.accessFeePerDay))
            }
        }
    }

    private var feeSection: some View {
        DetailCard(title: "Duration and fee estimate", systemImage: "dollarsign.circle") {
            Stepper(value: $durationDays, in: 1...30) {
                HStack {
                    Text("Requested / actual duration")
                    Spacer()
                    Text("\(durationDays) days")
                        .fontWeight(.semibold)
                        .monospacedDigit()
                }
            }

            if let book = resource as? PrintedBook {
                let estimatedPenalty = latePenalty(durationDays: durationDays, loanPeriodDays: book.loanPeriodDays, feePerDay: book.lateFeePerDay)
                DetailRow(title: "Refundable deposit", value: feeText(book.refundableDeposit))
                DetailRow(title: "Estimated late penalty", value: feeText(estimatedPenalty))
                DetailRow(title: "Estimated total due", value: feeText(try? viewModel.calculateFee(for: resource, durationDays: durationDays, mode: .loan)))
            } else if let journal = resource as? AcademicJournal {
                if journal.isLoanable {
                    let estimatedPenalty = latePenalty(durationDays: durationDays, loanPeriodDays: journal.loanPeriodDays, feePerDay: journal.lateFeePerDay)
                    DetailRow(title: "Refundable deposit (loan)", value: feeText(journal.refundableDeposit))
                    DetailRow(title: "Estimated late penalty", value: feeText(estimatedPenalty))
                    DetailRow(title: "Estimated loan total", value: feeText(try? viewModel.calculateFee(for: resource, durationDays: durationDays, mode: .loan)))
                }
                DetailRow(title: "In-library access fee", value: feeText(journal.accessFee))
            } else if let digitalMaterial = resource as? DigitalMaterial {
                DetailRow(title: "Daily access fee", value: feeText(digitalMaterial.accessFeePerDay))
                DetailRow(title: "Estimated online access fee", value: feeText(try? viewModel.calculateFee(for: resource, durationDays: durationDays, mode: .digital)))
            }

            Text("Fees are shown in campus currency units (CU). Deposits are refundable; late penalties are estimates based on the selected duration.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private var actionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Actions")
                .font(.headline)

            if resource is PrintedBook {
                if resource.activeAccessCount > 0 {
                    actionButton("Return Book", systemImage: "arrow.uturn.backward", style: .primary) {
                        endAccess(successText: "The book was returned successfully.")
                    }
                } else {
                    actionButton("Borrow Book", systemImage: "book.fill", style: .primary) {
                        requestAccess(mode: .loan, successText: "The book was borrowed successfully.")
                    }
                }
            } else if let journal = resource as? AcademicJournal {
                if journal.isLoanable {
                    if resource.activeAccessCount > 0 {
                        actionButton("Return Journal", systemImage: "arrow.uturn.backward", style: .primary) {
                            endAccess(successText: "The journal loan was returned successfully.")
                        }
                    } else {
                        actionButton("Borrow Journal", systemImage: "text.book.closed.fill", style: .primary) {
                            requestAccess(mode: .loan, successText: "The journal was borrowed successfully.")
                        }
                    }
                    actionButton("Read In Library", systemImage: "building.2", style: .secondary) {
                        requestAccess(mode: .onsite, successText: "The in-library reading session has started.")
                    }
                } else {
                    actionButton("Borrow Issue", systemImage: "book.closed", style: .primary) {
                        requestAccess(mode: .loan, successText: "The journal was borrowed successfully.")
                    }
                    if resource.activeAccessCount > 0 {
                        actionButton("End Reading Session", systemImage: "checkmark", style: .secondary) {
                            endAccess(successText: "The in-library reading session has ended.")
                        }
                    } else {
                        actionButton("Read In Library", systemImage: "building.2", style: .secondary) {
                            requestAccess(mode: .onsite, successText: "The in-library reading session has started.")
                        }
                    }
                }
            } else if resource is DigitalMaterial {
                actionButton("Access Online", systemImage: "network", style: .primary) {
                    requestAccess(mode: .digital, successText: "Online access has started.")
                }
                if resource.activeAccessCount > 0 {
                    actionButton("End Online Session", systemImage: "xmark.circle", style: .secondary) {
                        endAccess(successText: "The online access session has ended.")
                    }
                }
            }
        }
    }

    private var errorAlertIsPresented: Binding<Bool> {
        Binding(
            get: { errorMessage != nil },
            set: { isPresented in
                if !isPresented { errorMessage = nil }
            }
        )
    }

    private func requestAccess(mode: AccessMode, successText: String) {
        do {
            try viewModel.requestAccess(to: resource, mode: mode)
            errorMessage = nil
            successMessage = successText
        } catch {
            successMessage = nil
            errorMessage = error.localizedDescription
        }
    }

    private func endAccess(successText: String) {
        do {
            try viewModel.endAccess(to: resource)
            errorMessage = nil
            successMessage = successText
        } catch {
            successMessage = nil
            errorMessage = error.localizedDescription
        }
    }

    @ViewBuilder
    private func actionButton(
        _ title: String,
        systemImage: String,
        style: ActionButtonStyle,
        action: @escaping () -> Void
    ) -> some View {
        if style == .primary {
            Button(action: action) {
                Label(title, systemImage: systemImage)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        } else {
            Button(action: action) {
                Label(title, systemImage: systemImage)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
    }

    private func feeText(_ amount: Decimal) -> String {
        "CU \(amount.formatted(.number.precision(.fractionLength(2))))"
    }

    private func feeText(_ amount: Decimal?) -> String {
        guard let amount else { return "Unavailable" }
        return feeText(amount)
    }

    private func latePenalty(durationDays: Int, loanPeriodDays: Int, feePerDay: Decimal) -> Decimal {
        feePerDay * Decimal(max(0, durationDays - loanPeriodDays))
    }
}

private enum ActionButtonStyle: Equatable {
    case primary
    case secondary
}

private struct DetailCard<Content: View>: View {
    let title: String
    let systemImage: String
    let content: Content

    init(title: String, systemImage: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.systemImage = systemImage
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.headline)
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

private struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer(minLength: 8)
            Text(value)
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}

private struct StatusBadgeForDetail: View {
    @ObservedObject var resource: LibraryResource

    var body: some View {
        let status = statusText
        Text(status)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .foregroundStyle(color(for: status))
            .background(color(for: status).opacity(0.13), in: Capsule())
    }

    private var statusText: String {
        if let digital = resource as? DigitalMaterial, digital.isExpired { return "Expired" }
        if let journal = resource as? AcademicJournal, !journal.isLoanable { return "In-Library Only" }
        if resource is DigitalMaterial {
            if !resource.isAvailable { return "Full" }
            if resource.activeAccessCount > 0 { return "\(resource.remainingAccessSlots) slots left" }
            return "Available"
        }
        return resource.isAvailable ? "Available" : "Borrowed"
    }

    private func color(for status: String) -> Color {
        switch status {
        case "Expired", "Full": return .red
        case "In-Library Only": return .orange
        case "Borrowed": return .purple
        case "Available": return .green
        default: return .blue
        }
    }
}
