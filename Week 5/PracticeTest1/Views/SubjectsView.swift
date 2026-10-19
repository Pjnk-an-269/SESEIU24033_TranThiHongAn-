import SwiftUI

/// A small second tab that makes all mock subjects visible in the app.
struct SubjectsView: View {
    @ObservedObject var manager: UniversityManager

    var body: some View {
        List(manager.subjects) { subject in
            LabeledContent(subject.name, value: "\(subject.credits) credits")
        }
        .navigationTitle("Subjects")
    }
}


#Preview {
    ContentView()
}
