import SwiftUI

struct Student: Identifiable {
    let id: String
    var name: String
    var gpa: Double
}

struct ContentView: View {
    @State private var students: [Student] = [
        Student(id: "S001", name: "An", gpa: 8.5),
        Student(id: "S002", name: "Binh", gpa: 9.0),
        Student(id: "S003", name: "Chi", gpa: 7.8)
    ]

    @State private var searchText = ""

    @State private var newId = ""
    @State private var newName = ""
    @State private var newGPA = ""

    @State private var updateId = ""
    @State private var updateName = ""
    @State private var updateGPA = ""

    @State private var deleteId = ""

    @State private var showHighGPAOnly = false
    @State private var sortByGPA = false
    @State private var message = ""

    private var filteredStudents: [Student] {
        var result = students

        if !searchText.isEmpty {
            result = result.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }

        if showHighGPAOnly {
            result = result.filter { $0.gpa >= 8.0 }
        }

        if sortByGPA {
            result = result.sorted { $0.gpa > $1.gpa }
        }

        return result
    }

    private var highestGPAStudent: Student? {
        students.max { $0.gpa < $1.gpa }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 10) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.blue)

                        Text("Student Manager")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Total students: \(students.count)")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                }

                Section("Search") {
                    TextField("Search student by name", text: $searchText)
                }

                Section("Add Student") {
                    TextField("Student ID", text: $newId)
                    TextField("Name", text: $newName)
                    TextField("GPA", text: $newGPA)
                        .keyboardType(.decimalPad)

                    Button("Add Student") {
                        addStudent()
                    }
                }

                Section("Update Student") {
                    TextField("ID to update", text: $updateId)
                    TextField("New name", text: $updateName)
                    TextField("New GPA", text: $updateGPA)
                        .keyboardType(.decimalPad)

                    Button("Update Student") {
                        updateStudent()
                    }
                }

                Section("Remove Student") {
                    TextField("ID to remove", text: $deleteId)

                    Button("Remove Student", role: .destructive) {
                        removeStudent()
                    }
                }

                Section("Options") {
                    Toggle("Show GPA >= 8.0", isOn: $showHighGPAOnly)
                    Toggle("Sort by GPA descending", isOn: $sortByGPA)

                    if let bestStudent = highestGPAStudent {
                        Text("Highest GPA: \(bestStudent.name) - \(bestStudent.gpa, specifier: "%.1f")")
                    }
                }

                Section("Student List") {
                    ForEach(filteredStudents) { student in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundStyle(.blue)
                                .font(.title2)

                            VStack(alignment: .leading) {
                                Text(student.name)
                                    .font(.headline)

                                Text("ID: \(student.id) - GPA: \(student.gpa, specifier: "%.1f")")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteStudentBySwipe)
                }

                if !message.isEmpty {
                    Section("Message") {
                        Text(message)
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
    }

    private func addStudent() {
        guard !newId.isEmpty, !newName.isEmpty else {
            message = "Please enter student ID and name."
            return
        }

        guard let gpa = Double(newGPA) else {
            message = "GPA must be a number, for example 8.5."
            return
        }

        let student = Student(id: newId, name: newName, gpa: gpa)
        students.append(student)

        newId = ""
        newName = ""
        newGPA = ""
        message = "Student added successfully."
    }

    private func removeStudent() {
        let oldCount = students.count

        students.removeAll { student in
            student.id == deleteId
        }

        if students.count < oldCount {
            message = "Student removed successfully."
        } else {
            message = "Student ID not found."
        }

        deleteId = ""
    }

    private func updateStudent() {
        guard let gpa = Double(updateGPA) else {
            message = "New GPA must be a number."
            return
        }

        if let index = students.firstIndex(where: { $0.id == updateId }) {
            students[index].name = updateName
            students[index].gpa = gpa

            updateId = ""
            updateName = ""
            updateGPA = ""
            message = "Student updated successfully."
        } else {
            message = "Student ID not found."
        }
    }

    private func deleteStudentBySwipe(at offsets: IndexSet) {
        for offset in offsets {
            let student = filteredStudents[offset]

            students.removeAll {
                $0.id == student.id
            }
        }

        message = "Student removed successfully."
    }
}

#Preview {
    ContentView()
}
