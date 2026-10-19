import Foundation

/// The registration and result for one student taking one subject.
final class StudentRecord: Identifiable {
    let id: UUID
    let student: Student
    let subject: Subject

    private var storedMark: Double

    /// Custom getter/setter: every assignment is clamped into the valid 0.0...10.0 range.
    /// For example, assigning 11.0 stores 10.0, and assigning -2.0 stores 0.0.
    var mark: Double {
        get { storedMark }
        set { storedMark = Self.validMark(from: newValue) }
    }

    init(id: UUID = UUID(), student: Student, subject: Subject, mark: Double) {
        self.id = id
        self.student = student
        self.subject = subject
        self.storedMark = Self.validMark(from: mark)
    }

    func isPassed() -> Bool {
        mark >= 5.0
    }

    private static func validMark(from value: Double) -> Double {
        // NaN and infinity are also rejected so the stored mark is always valid.
        guard value.isFinite else { return 0.0 }
        return min(max(value, 0.0), 10.0)
    }
}
