import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.title2)
                .foregroundStyle(.blue)

            TextField("Search for fish, aquatic plants, accessories...", text: $searchText)
                .textInputAutocapitalization(.never)

            Button {
                searchText = ""
            } label: {
                Image(systemName: searchText.isEmpty ? "qrcode.viewfinder" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.blue)
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 18))
        .shadow(color: .blue.opacity(0.08), radius: 8, y: 3)
        .padding(.horizontal)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
            .padding()
            .background(.cyan.opacity(0.12))
    }
}
