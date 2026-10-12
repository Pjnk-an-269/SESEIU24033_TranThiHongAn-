//
//  Subject.swift
//  Lab_04_SchoolApp
//
//  Created by Tran An on 12/10/26.
//

import Foundation

class Subject {
    // 1. Thuộc tính (Properties)
    private var id: String
    private var name: String
    private var credits: Int
    private var semester: Int
    
    // 2. Hàm khởi tạo (Constructors)
    init() {
        self.id = ""
        self.name = ""
        self.credits = 0
        self.semester = 0
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.credits = 0
        self.semester = 0
    }
    
    init(id: String, name: String, credits: Int, semester: Int) {
        self.id = id
        self.name = name
        self.credits = credits
        self.semester = semester
    }
    
    // 3. Getter Methods
    func getId() -> String { return id }
    func getName() -> String { return name }
    func getCredits() -> Int { return credits }
    func getSemester() -> Int { return semester }
    
    // 4. Setter Methods
    func setId(_ newId: String) { self.id = newId }
    func setName(_ newName: String) { self.name = newName }
    func setCredits(_ newCredits: Int) { self.credits = newCredits }
    func setSemester(_ newSemester: Int) { self.semester = newSemester }
    
    // 5. Hiển thị thông tin
    func displayInfo() {
        print("ID: \(id), Name: \(name), Credits: \(credits), Semester: \(semester)")
    }
}
