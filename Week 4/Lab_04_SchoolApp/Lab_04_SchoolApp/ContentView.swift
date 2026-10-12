//
//  ContentView.swift
//  Lab_04_SchoolApp
//
//  Created by Tran An on 12/10/26.
//

//
//  ContentView.swift
//  Lab_04_SchoolApp
//
//  Created by Tran An on 12/10/26.
//

import SwiftUI

struct ContentView: View {
    // Biến lưu trữ chuỗi kết quả để hiển thị lên màn hình
    @State private var outputText: String = "Nhấn nút bên dưới để chạy chương trình..."
    
    var body: some View {
        VStack {
            Text("School Management System (2026-2027)")
                .font(.title2)
                .bold()
                .padding()
            
            // Vùng hiển thị kết quả (Console thu nhỏ)
            ScrollView {
                Text(outputText)
                    .font(.system(.body, design: .monospaced)) // Font chữ giống code
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Button("Run Full Test & Show Output") {
                runSchoolManagementSystem()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
    
    // Hàm thực thi tổng hợp thử nghiệm
    func runSchoolManagementSystem() {
        // Xóa kết quả cũ
        outputText = ""
        
        // Hàm phụ trợ để thêm dòng vào outputText
        func log(_ message: String) {
            outputText += message + "\n"
        }
        
        log("=============================================")
        log("=== SCHOOL MANAGEMENT SYSTEM (2026-2027) ===")
        log("=============================================\n")
        
        // 1. Tạo danh sách các môn học (Subjects)
        let s1 = Subject(id: "CSE101", name: "iOS Programming", credits: 3, semester: 1)
        let s2 = Subject(id: "CSE201", name: "Data Structures", credits: 4, semester: 2)
        let s3 = Subject(id: "CSE301", name: "Algorithms", credits: 3, semester: 3)
        
        // 2. Tạo danh sách Giảng viên (Teachers) và gán môn học
        let t1 = Teacher(id: "T001", name: "Nguyen Van A", subjects: [s1, s2], department: "IT")
        let t2 = Teacher(id: "T002", name: "Tran Thi B", subjects: [s3], department: "CS")
        
        log("--- Teachers Information ---")
        // Vì displayInfo() dùng print() ra Console, chúng ta cần gọi thủ công để lấy text
        // Hoặc đơn giản là vẫn giữ print ở Console và hiển thị text tóm tắt ở đây.
        // Cách tốt nhất là in ra Console như cũ, và ở đây chúng ta lấy thông tin qua Getter.
        
        log("Teacher: \(t1.getName()) - Dept: \(t1.getDepartment())")
        log("Total credits taught by T001: \(t1.getTotalCredits())")
        log("Subjects: \(t1.getSubjects().map { $0.getName() }.joined(separator: ", "))\n")
        
        log("Teacher: \(t2.getName()) - Dept: \(t2.getDepartment())")
        log("Subjects: \(t2.getSubjects().map { $0.getName() }.joined(separator: ", "))\n")
        log("----------------------------")
        
        // 3. Tạo danh sách Sinh viên (Students)
        let st1 = Student(id: "SV001", name: "Le Minh", age: 19, gpa: 2.9)
        let st2 = Student(id: "SV002", name: "Pham Hoa", age: 20, gpa: 3.6)
        let st3 = Student(id: "SV003", name: "Tran An", age: 19, gpa: 3.0)
        
        log("--- Students Information ---")
        log("ID: \(st1.getId()), Name: \(st1.getName()), Age: \(st1.getAge()), GPA: \(st1.getGPA())")
        log("ID: \(st2.getId()), Name: \(st2.getName()), Age: \(st2.getAge()), GPA: \(st2.getGPA())")
        log("ID: \(st3.getId()), Name: \(st3.getName()), Age: \(st3.getAge()), GPA: \(st3.getGPA())")
        log("Is SV002 Excellent? \(st2.isExcellent() ? "Yes" : "No")")
        log("\n----------------------------")
        
        // 4. Quản lý Điểm thi Sinh viên (StudentSubjects)
        let r1 = StudentSubjects(studentId: "SV001", courseId: "CSE101", year: 2026, mark: 8.5)
        let r2 = StudentSubjects(studentId: "SV001", courseId: "CSE201", year: 2026, mark: 7.0)
        let r3 = StudentSubjects(studentId: "SV002", courseId: "CSE101", year: 2026, mark: 9.0)
        
        log("--- Student Marks & Records ---")
        log("Student: \(r1.getStudentId()), Course: \(r1.getCourseId()), Mark: \(r1.getMark())")
        log("Student: \(r2.getStudentId()), Course: \(r2.getCourseId()), Mark: \(r2.getMark())")
        log("Student: \(r3.getStudentId()), Course: \(r3.getCourseId()), Mark: \(r3.getMark())")
        log("=============================================\n")
        
        // Vẫn in ra Console để giữ nguyên logic gốc của bài Lab
        print("Đã chạy xong kịch bản! Kiểm tra Console (Shift + Cmd + Y) để xem chi tiết.")
    }
}

#Preview {
    ContentView()
}
