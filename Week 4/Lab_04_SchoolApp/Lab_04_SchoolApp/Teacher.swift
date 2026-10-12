//
//  Teacher.swift
//  Lab_04_SchoolApp
//
//  Created by Tran An on 12/10/26.
//

import Foundation

class Teacher {
    // 1. Thuộc tính (Properties)
    private var id: String
    private var name: String
    private var subjects: [Subject] // Mảng chứa các môn học
    private var department: String
    
    // 2. Hàm khởi tạo (Constructors)
    init() {
        self.id = ""
        self.name = ""
        self.subjects = []
        self.department = ""
    }
    
    init(id: String, name: String, subjects: [Subject], department: String) {
        self.id = id
        self.name = name
        self.subjects = subjects
        self.department = department
    }
    
    // 3. Getter & Setter Methods
    func getId() -> String { return id }
    func getName() -> String { return name }
    func getSubjects() -> [Subject] { return subjects }
    func getDepartment() -> String { return department }
    
    func setId(_ newId: String) { self.id = newId }
    func setName(_ newName: String) { self.name = newName }
    func setSubjects(_ newSubjects: [Subject]) { self.subjects = newSubjects }
    func setDepartment(_ newDepartment: String) { self.department = newDepartment }
    
    // 4. Quản lý môn học
    func addSubject(_ subject: Subject) {
        subjects.append(subject)
    }
    
    func removeSubject(id: String) {
        subjects.removeAll { $0.getId() == id }
    }
    
    // Tính tổng số tín chỉ giảng dạy (Extended Practice)
    func getTotalCredits() -> Int {
        return subjects.reduce(0) { $0 + $1.getCredits() }
    }
    
    // 5. Hiển thị thông tin
    func displayInfo() {
        print("ID: \(id), Name: \(name), Department: \(department)")
        print("Subjects:")
        if subjects.isEmpty {
            print("  (None)")
        } else {
            for subject in subjects {
                print("  - [\(subject.getId())] \(subject.getName()) (Credits: \(subject.getCredits()), Semester: \(subject.getSemester()))")
            }
        }
    }
}
