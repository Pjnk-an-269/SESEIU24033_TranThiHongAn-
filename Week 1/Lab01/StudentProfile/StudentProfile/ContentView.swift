import SwiftUI

struct ContentView: View {

    // Student information
    let studentName = "Trần Thị Hồng Ân"
    let studentID = "SESEIU24033"
    let age = 19
    let gpa = 8.0
    let isStudent = true

    var body: some View {
        ZStack {

            // Background
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.15),
                    Color.purple.opacity(0.10),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Cute star decorations
            VStack {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .font(.title2)

                    Spacer()

                    Image(systemName: "star.fill")
                        .foregroundStyle(.pink.opacity(0.6))
                        .font(.title3)
                }

                Spacer()

                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.purple.opacity(0.5))
                        .font(.title3)

                    Spacer()

                    Image(systemName: "star.fill")
                        .foregroundStyle(.blue.opacity(0.5))
                        .font(.title2)
                }
            }
            .padding(30)

            // Main content
            ScrollView {
                VStack(spacing: 20) {

                    // Profile image
                    Image("Cute")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 5)
                        )
                        .shadow(radius: 8)

                    // Title
                    Text("Student Profile")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.blue)

                    Text("A little introduction about me ✨")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    // Information card
                    VStack(spacing: 12) {

                        ProfileRow(
                            icon: "person.fill",
                            title: "Name",
                            value: studentName,
                            color: .blue
                        )

                        ProfileRow(
                            icon: "graduationcap.fill",
                            title: "Student ID",
                            value: studentID,
                            color: .purple
                        )

                        ProfileRow(
                            icon: "calendar",
                            title: "Age",
                            value: "\(age)",
                            color: .orange
                        )

                        ProfileRow(
                            icon: "chart.bar.fill",
                            title: "GPA",
                            value: String(format: "%.1f", gpa),
                            color: .green
                        )

                        ProfileRow(
                            icon: "checkmark.circle.fill",
                            title: "Student",
                            value: isStudent ? "true" : "false",
                            color: .green
                        )
                    }
                    .padding(16)
                    .background(.white.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.08), radius: 10)

                    // Footer
                    Text("Keep learning, keep growing 🌷")
                        .font(.footnote)
                        .italic()
                        .foregroundStyle(.secondary)
                }
                .padding(24)
            }
        }
    }
}

// Reusable row for student information
struct ProfileRow: View {

    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.body)
                    .bold()
            }

            Spacer()
        }
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    ContentView()
}
