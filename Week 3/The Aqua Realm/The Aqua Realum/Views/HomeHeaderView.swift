import SwiftUI

struct HomeHeaderView: View {
    var storeName: String
    var subtitle: String
    var notificationCount: Int = 3
    var cartCount: Int = 2

    var body: some View {
        // Sử dụng .center để toàn bộ khối chữ và nút cân bằng theo trục ngang của Logo
        HStack(alignment: .center, spacing: 12) {
            
            // --- CỤM LOGO TRÒN ---
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 58, height: 58)
                Image("fishlogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
            }
            .frame(width: 58, height: 58)

            // --- CỤM NỘI DUNG CHỮ & ICON ---
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 8) {
                    Text(storeName)
                        .font(.title2.bold())
                        .foregroundStyle(.blue)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    BadgeButton(systemName: "bell.fill", count: notificationCount)
                    BadgeButton(systemName: "cart.fill", count: cartCount)
                }

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

private struct BadgeButton: View {
    var systemName: String
    var count: Int

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Circle()
                .fill(.white)
                .frame(width: 42, height: 42)
                .shadow(color: .black.opacity(0.08), radius: 3, y: 1.5)
                .overlay {
                    Image(systemName: systemName)
                        .font(.body)
                        .foregroundStyle(.blue)
                }

            Text("\(count)")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.white)
                .padding(4)
                .background(.red, in: Circle())
                .offset(x: 3, y: -3)
        }
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView(storeName: "The Aqua Realm", subtitle: "Your ultimate underwater plug ✨")
            .background(.cyan.opacity(0.15))
            .font(.caption)
            .foregroundColor(.black)
            .fixedSize(horizontal: false, vertical: true)
    }
}
