import SwiftUI
import Foundation

struct UpdateMarkView: View {
    @ObservedObject var manager: UniversityManager
    let record: StudentRecord

    @Environment(\.dismiss) private var dismiss
    @State private var markText: String

    init(manager: UniversityManager, record: StudentRecord) {
        self.manager = manager
        self.record = record
        _markText = State(initialValue: String(format: "%.1f", record.mark))
    }

    private var enteredMark: Double? {
        Double(markText)
    }

    private var hasValidMark: Bool {
        guard let enteredMark else { return false }
        return (0.0...10.0).contains(enteredMark)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Registration") {
                    LabeledContent("Student", value: record.student.name)
                    LabeledContent("Subject", value: record.subject.name)
                }

                Section("New Mark") {
                    TextField("0.0 to 10.0", text: $markText)
                        .keyboardType(.decimalPad)

                    Text("Enter a mark from 0.0 to 10.0.")
                        .font(.caption)
                        .foregroundStyle(hasValidMark ? Color.secondary : Color.red)
                }
            }
            .navigationTitle("Update Mark")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let enteredMark else { return }
                        manager.updateMark(for: record, to: enteredMark)
                        dismiss()
                    }
                    .disabled(!hasValidMark)
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
