import SwiftUI

struct IUHeaderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image("iulogo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            VStack(spacing: 4) {
                Text("ĐẠI HỌC QUỐC GIA TP. HỒ CHÍ MINH")
                    .font(.caption)
                    .fontWeight(.bold)
                Text("TRƯỜNG ĐẠI HỌC QUỐC TẾ")
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.6)) 
        }
        .padding(.top, 20)
    }
}


#Preview {
    ContentView()
}
