import Foundation

/// Demo data required for the practice test: 4 students, 4 subjects, and 8 records.
struct MockData {
    let students: [Student]
    let subjects: [Subject]
    let records: [StudentRecord]

    static func makeSample() -> MockData {
        let an = Student(id: "SESEIU24033", name: "Tran Thi Hong An", age: 20)
        let binh = Student(id: "SESEIU24001", name: "Tran Gia Binh", age: 21)
        let chi = Student(id: "SESEIU24015", name: "Le Thu Chi", age: 19)
        let dung = Student(id: "SESEIU24019", name: "Pham Quang Dung", age: 22)

        let swift = Subject(id: "SUB001", name: "iOS programing fundamentals", credits: 3)
        let database = Subject(id: "SUB002", name: "Database Systems", credits: 4)
        let algorithms = Subject(id: "SUB003", name: "Algorithms", credits: 3)
        let english = Subject(id: "SUB004", name: "Academic English", credits: 2)

        let records = [
            StudentRecord(student: an, subject: swift, mark: 9.0),
            StudentRecord(student: an, subject: database, mark: 8.0),
            StudentRecord(student: binh, subject: algorithms, mark: 7.5),
            StudentRecord(student: binh, subject: english, mark: 6.5),
            StudentRecord(student: chi, subject: swift, mark: 5.0),
            StudentRecord(student: chi, subject: database, mark: 4.0),
            StudentRecord(student: dung, subject: algorithms, mark: 9.5),
            StudentRecord(student: dung, subject: english, mark: 9.0)
        ]

        return MockData(
            students: [an, binh, chi, dung],
            subjects: [swift, database, algorithms, english],
            records: records
        )
    }
}
