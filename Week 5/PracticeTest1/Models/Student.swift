import Foundation

/// A university student. This stays separate from Subject and StudentRecord.
final class Student: Identifiable {
    var id: String
    var name: String

    private var storedAge: Int

    /// The setter guarantees that a student can never have a negative age.
    var age: Int {
        get { storedAge }
        set { storedAge = max(0, newValue) }
    }

    init(id: String, name: String, age: Int) {
        self.id = id
        self.name = name
        self.storedAge = max(0, age)
    }

    func displayInfo() -> String {
        "ID: \(id) | Name: \(name) | Age: \(age)"
    }
}
