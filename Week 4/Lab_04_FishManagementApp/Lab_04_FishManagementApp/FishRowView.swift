import SwiftUI

struct FishRowView: View {
    let fish: Fish
    
    var body: some View {
        HStack(spacing: 16) {
            
            let imageName = fish.getImageName()
            let isSystemImage = imageName.contains(".") 
            
            Group {
                if isSystemImage {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(fish.getColorValue())
                } else {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 45, height: 45)
            .cornerRadius(8)
            
            // Thông tin tên và giá
            VStack(alignment: .leading, spacing: 4) {
                Text(fish.getName())
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("\(fish.getColor()) - $\(String(format: "%.1f", fish.getPrice()))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.5))
                .font(.system(size: 14, weight: .bold))
        }
        .padding(.vertical, 8)
    }
}

struct FishRowView_Previews: PreviewProvider {
    static var previews: some View {
        FishRowView(fish: Fish(id: 1, name: "Neon Fish", color: "Red", price: 20.0))
            .previewLayout(.sizeThatFits)
    }
}
