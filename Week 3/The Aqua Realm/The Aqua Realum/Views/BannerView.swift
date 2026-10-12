import SwiftUI

struct BannerView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            LinearGradient(
                colors: [.cyan.opacity(0.35), .green.opacity(0.25), .blue.opacity(0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("MONTHLY DEALS")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.blue, in: Capsule())

                    Text("Healthy Fish - Beautiful Tanks")
                        .font(.title2.bold())
                        .foregroundStyle(.teal)

                    Text("Relaxing spaces for every home")
                        .font(.subheadline)
                        .foregroundStyle(.primary)

                    HStack(spacing: 12) {
                        BannerFeature(icon: "truck.box.fill", title: "Delivery")
                        BannerFeature(icon: "checkmark.shield.fill", title: "Secure")
                        BannerFeature(icon: "leaf.fill", title: "Support")
                    }
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(.orange)
                        .frame(width: 93, height: 93)

                    Text("Discount\n30%")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
    }
}

private struct BannerFeature: View {
    var icon: String
    var title: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(.blue)

            Text(title)
                .font(.caption2.bold())
        }
        .frame(width: 64, height: 56)
        .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        BannerView()
    }
}
