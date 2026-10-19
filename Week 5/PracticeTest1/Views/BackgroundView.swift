import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [Color.blue.opacity(0.15), Color.purple.opacity(0.05), .white],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
