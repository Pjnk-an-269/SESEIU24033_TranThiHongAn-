//
//  StudentSubjects.swift
//  Lab_04_SchoolApp
//
//  Created by Tran An on 12/10/26.
//

import Foundation

class StudentSubjects {
    // 1. Thuộc tính (Properties)
    private var studentId: String
    private var courseId: String
    private var year: Int
    private var mark: Double
    
    // 2. Hàm khởi tạo (Constructors)
    init() {
        self.studentId = ""
        self.courseId = ""
        self.year = 0
        self.mark = 0.0
    }
    
    init(studentId: String) {
        self.studentId = studentId
        self.courseId = ""
        self.year = 0
        self.mark = 0.0
    }
    
    init(studentId: String, courseId: String) {
        self.studentId = studentId
        self.courseId = courseId
        self.year = 0
        self.mark = 0.0
    }
    
    init(studentId: String, courseId: String, year: Int, mark: Double) {
        self.studentId = studentId
        self.courseId = courseId
        self.year = year
        self.mark = mark
    }
    
    // 3. Getter & Setter Methods
    func getStudentId() -> String { return studentId }
    func getCourseId() -> String { return courseId }
    func getYear() -> Int { return year }
    func getMark() -> Double { return mark }
    
    func setStudentId(_ newStudentId: String) { self.studentId = newStudentId }
    func setCourseId(_ newCourseId: String) { self.courseId = newCourseId }
    func setYear(_ newYear: Int) { self.year = newYear }
    func setMark(_ newMark: Double) { self.mark = newMark }
    
    // 4. Các hàm mở rộng (Extended Practice)
    func isPassed() -> Bool {
        return mark >= 5.0
    }
    
    func updateMark(_ newMark: Double) {
        self.mark = newMark
    }
    
    func displayInfo() {
        print("Student: \(studentId), Course: \(courseId), Year: \(year), Mark: \(mark)")
    }
}
