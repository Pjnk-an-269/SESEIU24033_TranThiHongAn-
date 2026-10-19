import SwiftUI

struct RankItem: Identifiable {
    var id: String { name }
    let name: String
    let color: Color
    let icon: String
    let range: Range<Double>
}

struct AcademicResultView: View {
    @EnvironmentObject var manager: UniversityManager
    
    let ranks = [
        RankItem(name: "EXCELLENT", color: .green, icon: "star.fill", range: 8.5..<10.1),
        RankItem(name: "GOOD", color: .blue, icon: "hand.thumbsup.fill", range: 7.0..<8.5),
        RankItem(name: "AVERAGE", color: .orange, icon: "circle.fill", range: 5.0..<7.0),
        RankItem(name: "FAIL", color: .red, icon: "exclamationmark.triangle.fill", range: 0.0..<5.0)
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ranks) { rank in
                    let studentsInRank = manager.students.filter { student in
                        let gpa = manager.weightedAverage(for: student)
                        return rank.range.contains(gpa)
                    }
                    
                    Section {
                        if studentsInRank.isEmpty {
                            Text("No students in this rank.")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        } else {
                            ForEach(studentsInRank) { student in
                                HStack {
                                    Circle()
                                        .fill(rank.color.opacity(0.2))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Text(String(student.name.prefix(1)))
                                                .foregroundColor(rank.color)
                                                .bold()
                                        )
                                    
                                    VStack(alignment: .leading) {
                                        Text(student.name).font(.headline)
                                        Text(student.id).font(.caption).foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(String(format: "%.2f", manager.weightedAverage(for: student)))
                                        .bold()
                                        .foregroundColor(rank.color)
                                }
                            }
                        }
                    } header: {
                        HStack {
                            Image(systemName: rank.icon)
                            Text(rank.name)
                            Spacer()
                            Text("\(studentsInRank.count) students")
                                .font(.caption).textCase(.none)
                        }
                        .foregroundColor(rank.color)
                    }
                }
            }
            .navigationTitle("Academic Ranking")
        }
    }
}
