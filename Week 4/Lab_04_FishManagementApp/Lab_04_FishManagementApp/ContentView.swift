//
//  ContentView.swift
//  Lab_04_FishManagementApp
//
//  Created by Tran An on 12/10/26.
//

import SwiftUI

struct ContentView: View {
    @State private var fishes: [Fish] = [
        Fish(id: 1, name: "Neon Fish", color: "Red", price: 20.0),
        Fish(id: 2, name: "Betta Fish", color: "Blue", price: 35.0),
        Fish(id: 3, name: "Goldfish", color: "Orange", price: 25.0),
        Fish(id: 4, name: "Angelfish", color: "Silver", price: 40.0)
    ]
    
    @State private var showingAddFishSheet = false
    
    var body: some View {
        TabView {
            // Tab 1: Fishes
            NavigationView {
                List {
                    ForEach(fishes) { fish in
                        FishRowView(fish: fish)
                    }
                    .onDelete(perform: deleteFish) // Thêm tính năng vuốt để xóa (tuỳ chọn)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("My Aquarium")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingAddFishSheet = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                }
                .sheet(isPresented: $showingAddFishSheet) {
                    AddFishView(fishes: $fishes)
                }
            }
            .tabItem {
                Label("Fishes", systemImage: "fish.fill")
            }
            
            // Tab 2: Statistics
            StatisticsView(fishes: fishes)
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
        }
    }
    
    // Hàm xử lý xóa cá khỏi danh sách 
    private func deleteFish(at offsets: IndexSet) {
        fishes.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
