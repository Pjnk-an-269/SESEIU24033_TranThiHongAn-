import Foundation

class Student {
    // 1. Thuộc tính (Properties) - Đóng gói với private
    private var id: String
    private var name: String
    private var age: Int
    private var gpa: Double
    
    // 2. Các hàm khởi tạo (Constructors / Initializers)
    init() {
        self.id = ""
        self.name = ""
        self.age = 0
        self.gpa = 0.0
    }
    
    init(id: String) {
        self.id = id
        self.name = ""
        self.age = 0
        self.gpa = 0.0
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.age = 0
        self.gpa = 0.0
    }
    
    init(id: String, name: String, age: Int, gpa: Double) {
        self.id = id
        self.name = name
        self.age = age
        self.gpa = gpa
    }
    
    // 3. Getter Methods
    func getId() -> String { return id }
    func getName() -> String { return name }
    func getAge() -> Int { return age }
    func getGPA() -> Double { return gpa }
    
    // 4. Setter Methods
    func setId(_ newId: String) { self.id = newId }
    func setName(_ newName: String) { self.name = newName }
    func setAge(_ newAge: Int) { self.age = newAge }
    func setGPA(_ newGPA: Double) { self.gpa = newGPA }
    
    // 5. Các phương thức khác
    func displayInfo() {
        print("ID: \(id), Name: \(name), Age: \(age), GPA: \(gpa)")
    }
    
    func isExcellent() -> Bool {
        return gpa >= 3.5
    }
    
    func updateGPA(_ newGPA: Double) {
        self.gpa = newGPA
    }
}
