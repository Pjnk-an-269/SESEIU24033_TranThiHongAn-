import SwiftUI

struct StudentListView: View {
    @ObservedObject var manager: UniversityManager

    var body: some View {
        ZStack {
            // 1. Lớp nền dưới cùng
            BackgroundView()
            
            VStack(alignment: .leading) {
                // 2. Cụm Logo và Tên trường nằm giữa
                HStack {
                    Spacer()
                    IUHeaderView()
                    Spacer()
                }
                
                // 3. Tiêu đề tuỳ chỉnh
                Text("Students")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                // 4. Danh sách sinh viên (Giữ nguyên logic của bạn)
                List(manager.students) { student in
                    NavigationLink {
                        StudentDetailView(manager: manager, student: student)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(student.name)
                                .font(.headline)
                            // Đã sửa lại hiển thị ID và Tuổi trên cùng 1 dòng
                            Text("\(student.id) - Age \(student.age)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .listStyle(.plain) // Bỏ viền mặc định của List
                .scrollContentBackground(.hidden) // Xóa nền trắng để lộ BackgroundView
            }
        }
        // Ẩn thanh Navigation Title mặc định của hệ thống
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    ContentView()
}
