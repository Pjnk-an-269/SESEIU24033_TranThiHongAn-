//
//  Untitled.swift
//  Lab_04_FishManagementApp
//
//  Created by Tran An on 12/10/26.
//

import SwiftUI

struct AddFishView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var fishes: [Fish]
    
    @State private var name: String = ""
    @State private var selectedColor: String = "Red"
    @State private var price: String = ""
    
    let availableColors = ["Red", "Blue", "Orange", "Silver", "Gold", "Green"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Thông tin cá")) {
                    TextField("Tên cá (VD: Neon Fish)", text: $name)
                    
                    Picker("Màu sắc", selection: $selectedColor) {
                        ForEach(availableColors, id: \.self) { color in
                            Text(color).tag(color)
                        }
                    }
                    
                    TextField("Giá tiền (VD: 20.0)", text: $price)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Thêm Cá Mới")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Hủy") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Lưu") {
                        saveFish()
                    }
                    .disabled(name.isEmpty || price.isEmpty)
                }
            }
        }
    }
    
    private func saveFish() {
        guard let priceDouble = Double(price) else { return }
        
        // Tạo ID mới tự động tăng dựa trên ID lớn nhất hiện có
        let newId = (fishes.map { $0.getId() }.max() ?? 0) + 1
        
        let newFish = Fish(id: newId, name: name, color: selectedColor, price: priceDouble)
        fishes.append(newFish)
        dismiss()
    }
}
