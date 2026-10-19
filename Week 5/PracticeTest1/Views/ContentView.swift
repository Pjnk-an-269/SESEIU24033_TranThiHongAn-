import SwiftUI

struct ContentView: View {
    @StateObject private var manager = UniversityManager()

    var body: some View {
        TabView {
            NavigationStack {
                StudentListView(manager: manager)
            }
            .tabItem {
                Label("Students", systemImage: "person.3.fill")
            }

            NavigationStack {
                SubjectsView(manager: manager)
            }
            .tabItem {
                Label("Subjects", systemImage: "book.closed.fill")
            }
            
            AcademicResultView()
                .tabItem {
                    Label("Ranking", systemImage: "chart.bar.fill")
                }
        }
        .environmentObject(manager)
    }
}

#Preview {
    ContentView()
}
