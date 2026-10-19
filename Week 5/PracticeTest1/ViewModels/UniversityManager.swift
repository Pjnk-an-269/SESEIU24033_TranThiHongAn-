import Foundation
import Combine

/// The ViewModel owns app state and business rules; SwiftUI views only display it.
@MainActor
final class UniversityManager: ObservableObject {
    @Published private(set) var students: [Student]
    @Published private(set) var subjects: [Subject]
    @Published private(set) var studentRecords: [StudentRecord]

    init(mockData: MockData = MockData.makeSample()) {
        students = mockData.students
        subjects = mockData.subjects
        studentRecords = mockData.records
    }

    func records(for student: Student) -> [StudentRecord] {
        studentRecords.filter { $0.student.id == student.id }
    }

    /// Weighted GPA = sum(mark × subject credits) / sum(subject credits).
    /// A 4-credit result therefore contributes twice as much as a 2-credit result.
    func weightedAverage(for student: Student) -> Double {
        let records = records(for: student)
        let totalCredits = records.reduce(0) { $0 + $1.subject.credits }

        guard totalCredits > 0 else { return 0.0 }

        let weightedMarks = records.reduce(0.0) { partialResult, record in
            partialResult + record.mark * Double(record.subject.credits)
        }
        return weightedMarks / Double(totalCredits)
    }

    func academicRanking(for student: Student) -> String {
        switch weightedAverage(for: student) {
        case 8.5...:
            return "Excellent"
        case 7.0..<8.5:
            return "Good"
        case 5.0..<7.0:
            return "Average"
        default:
            return "Fail"
        }
    }

    /// Registers a subject only if the student has not already registered for it.
    /// Returns false for an attempted duplicate registration.
    @discardableResult
    func register(student: Student, for subject: Subject, mark: Double = 0.0) -> Bool {
        let alreadyRegistered = studentRecords.contains {
            $0.student.id == student.id && $0.subject.id == subject.id
        }

        guard !alreadyRegistered else { return false }

        studentRecords.append(StudentRecord(student: student, subject: subject, mark: mark))
        return true
    }

    func updateMark(for record: StudentRecord, to newMark: Double) {
        record.mark = newMark

        // StudentRecord is a reference type. Sending this notification makes all
        // observing SwiftUI views redraw after its mark has changed in place.
        objectWillChange.send()
    }
}
