import SwiftUI

struct TaskItem: Identifiable {
    let id = UUID()
    var title: String
    var category: String
    var icon: String
    var isCompleted: Bool
    var time: String
}

struct ContentView: View {
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<11:  return "Good Morning, 🌅"
        case 11..<14: return "Good Noon, ☀️"
        case 14..<18: return "Good Afternoon, 🌇"
        default:      return "Good Evening, 🌙"
        }
    }

    @State private var tasks: [TaskItem] = [
        TaskItem(title: "Read chapter 2", category: "Study", icon: "book.fill", isCompleted: false, time: "09:00"),
        TaskItem(title: "Workout", category: "Health", icon: "figure.run", isCompleted: true, time: "17:00"),
        TaskItem(title: "Finish lab report", category: "Work", icon: "laptopcomputer", isCompleted: false, time: "20:00"),
        TaskItem(title: "Call family", category: "Personal", icon: "person.2.fill", isCompleted: false, time: "21:00")
    ]

    @State private var nextTemplateIndex = 0

    private let studentName = "Tran Thi Hong An"
    private let quote = "Sometimes later becomes never. Do it now."
    private let templates: [(title: String, category: String, icon: String, time: String)] = [
        ("Review Swift notes", "Study", "doc.text.fill", "08:30"),
        ("Drink water", "Health", "drop.fill", "10:00"),
        ("Clean desk", "Personal", "sparkles", "15:30"),
        ("Practice UI layout", "Work", "rectangle.3.group.fill", "19:00")
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.90, green: 0.97, blue: 1.00),
                    Color(red: 1.00, green: 0.97, blue: 0.90),
                    Color(red: 0.93, green: 0.98, blue: 0.90)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    headerSection
                    dateAndProgressSection
                    taskSection
                    summarySection
                }
                .padding()
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {

                Image("avt")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 6)
                {
                    Text(greetingText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)


                    Text(studentName)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.05, green: 0.19, blue: 0.38))
                }

            }

            Text(quote)
                .font(.callout)
                .foregroundStyle(Color(red: 0.19, green: 0.32, blue: 0.43))
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.82))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .padding(16)
        .background(Color.white.opacity(0.62))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
    }

    private var dateAndProgressSection: some View {
        HStack(spacing: 12) {
            VStack(spacing: 3) {
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundStyle(Color.blue)

                Text(dayNumber)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.07, green: 0.20, blue: 0.34))

                Text(shortWeekday)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 96, height: 112)
            .background(Color.white.opacity(0.86))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 10) {
                Text("New day")
                    .font(.headline)
                    .foregroundStyle(Color(red: 0.05, green: 0.19, blue: 0.38))

                Text("New opportunities")
                    .font(.subheadline)
                    .foregroundStyle(Color(red: 0.79, green: 0.36, blue: 0.15))

                ProgressView(value: completionRate)
                    .tint(Color.green)

                Text("\(completedCount)/\(tasks.count) tasks completed")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 112, alignment: .leading)
            .background(Color.white.opacity(0.86))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }

    private var taskSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("My Tasks", systemImage: "list.bullet.rectangle.fill")
                    .font(.headline)
                    .foregroundStyle(Color(red: 0.05, green: 0.19, blue: 0.38))

                Spacer()

                Button(action: addTask) {
                    Label("Add Task", systemImage: "plus")
                        .font(.caption)
                        .fontWeight(.bold)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.green)
            }

            VStack(spacing: 10) {
                ForEach($tasks) { $task in
                    TaskRowView(task: $task)
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.72))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }

    private var summarySection: some View {
        HStack(spacing: 12) {
            SummaryBox(title: "Study", value: categoryCount("Study"), color: .blue, icon: "book.closed.fill")
            SummaryBox(title: "Health", value: categoryCount("Health"), color: .red, icon: "heart.fill")
            SummaryBox(title: "Work", value: categoryCount("Work"), color: .orange, icon: "briefcase.fill")
        }
    }

    private var completedCount: Int {
        tasks.filter(\.isCompleted).count
    }

    private var completionRate: Double {
        guard !tasks.isEmpty else { return 0 }
        return Double(completedCount) / Double(tasks.count)
    }

    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: Date())
    }

    private var shortWeekday: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: Date())
    }

    private func categoryCount(_ category: String) -> Int {
        tasks.filter { $0.category == category }.count
    }

    private func addTask() {
        let template = templates[nextTemplateIndex % templates.count]
        tasks.append(
            TaskItem(
                title: template.title,
                category: template.category,
                icon: template.icon,
                isCompleted: false,
                time: template.time
            )
        )
        nextTemplateIndex += 1
    }
}

struct TaskRowView: View {
    @Binding var task: TaskItem

    var body: some View {
        HStack(spacing: 12) {
            Button {
                task.isCompleted.toggle()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(task.isCompleted ? Color.green : Color.gray)
            }
            .buttonStyle(.plain)

            Image(systemName: task.icon)
                .font(.headline)
                .foregroundStyle(categoryColor)
                .frame(width: 30, height: 30)
                .background(categoryColor.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? Color.secondary : Color.primary)

                Text(task.category)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(categoryColor.opacity(0.14))
                    .foregroundStyle(categoryColor)
                    .clipShape(Capsule())
            }

            Spacer()

            Text(task.time)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var categoryColor: Color {
        switch task.category {
        case "Study":
            return .blue
        case "Health":
            return .red
        case "Work":
            return .orange
        default:
            return .purple
        }
    }
}

struct SummaryBox: View {
    let title: String
    let value: Int
    let color: Color
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(color)

            Text("\(value)")
                .font(.system(size: 24, weight: .bold, design: .rounded))

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.84))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
