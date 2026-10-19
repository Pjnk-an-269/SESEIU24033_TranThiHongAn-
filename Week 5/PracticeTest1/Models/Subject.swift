import Foundation

/// A subject that can be registered by many students.
final class Subject: Identifiable {
    var id: String
    var name: String

    private var storedCredits: Int

    /// A subject must always be worth at least one credit.
    var credits: Int {
        get { storedCredits }
        set { storedCredits = max(1, newValue) }
    }

    init(id: String, name: String, credits: Int) {
        self.id = id
        self.name = name
        self.storedCredits = max(1, credits)
    }
}
