import SwiftUI

struct StudentDetailView: View {
    @ObservedObject var manager: UniversityManager
    let student: Student

    @State private var recordToEdit: StudentRecord?

    private var records: [StudentRecord] {
        manager.records(for: student)
    }

    var body: some View {
        List {
            Section("Student Information") {
                LabeledContent("Student ID", value: student.id)
                LabeledContent("Name", value: student.name)
                LabeledContent("Age", value: "\(student.age)")
            }

            Section("Academic Result") {
                LabeledContent("Weighted GPA", value: manager.weightedAverage(for: student).formatted(.number.precision(.fractionLength(2))))
                LabeledContent("Academic ranking", value: manager.academicRanking(for: student))
            }

            Section("Registered Subjects") {
                if records.isEmpty {
                    Label("No registrations", systemImage: "book.closed")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(records) { record in
                        Button {
                            recordToEdit = record
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(record.subject.name)
                                        .foregroundStyle(.primary)
                                    Text("\(record.subject.credits) credits")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 4) {
                                    Text(record.mark.formatted(.number.precision(.fractionLength(1))))
                                        .font(.headline)
                                        .foregroundStyle(record.isPassed() ? .green : .red)
                                    Text(record.isPassed() ? "Passed" : "Failed")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .accessibilityHint("Tap to update this mark")
                    }
                }
            }
        }
        .navigationTitle(student.name)
        .sheet(item: $recordToEdit) { record in
            UpdateMarkView(manager: manager, record: record)
        }
    }
}


#Preview {
    ContentView()
}
