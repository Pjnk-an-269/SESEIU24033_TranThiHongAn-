import SwiftUI

struct MapView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Store Map")
                .font(.title3.bold())

            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(.blue.opacity(0.08))
                    .frame(height: 180)

                VStack(spacing: 12) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.red)

                    Text("Pretty Aquatic Fish")
                        .font(.headline)

                    Text("Quarter 6, Dong Hoa Ward, Di An City, Binh Duong Province")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }

            HStack {
                Label("Fast city delivery available", systemImage: "truck.box.fill")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .font(.subheadline)
            .foregroundStyle(.blue)
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
