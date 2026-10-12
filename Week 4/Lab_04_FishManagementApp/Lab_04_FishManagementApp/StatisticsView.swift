//
//  StatisticsView.swift
//  Lab_04_FishManagementApp
//
//  Created by Tran An on 12/10/26.
//

import SwiftUI

struct StatisticsView: View {
    let fishes: [Fish]
    
    private var totalFish: Int { fishes.count }
    
    private var totalValue: Double {
        fishes.reduce(0) { $0 + $1.getPrice() }
    }
    
    private var averagePrice: Double {
        guard totalFish > 0 else { return 0 }
        return totalValue / Double(totalFish)
    }
    
    private var mostExpensiveFish: Fish? {
        fishes.max(by: { $0.getPrice() < $1.getPrice() })
    }
    
    private var cheapestFish: Fish? {
        fishes.min(by: { $0.getPrice() < $1.getPrice() })
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Overview")) {
                    StatisticRow(title: "Total Fish Count", value: "\(totalFish) \(totalFish == 1 ? "fish" : "fishes")", icon: "fish.fill", color: .blue)
                    StatisticRow(title: "Total Aquarium Value", value: "$\(String(format: "%.2f", totalValue))", icon: "dollarsign.circle.fill", color: .green)
                    StatisticRow(title: "Average Price", value: "$\(String(format: "%.2f", averagePrice))", icon: "chart.bar.fill", color: .orange)
                }
                
                Section(header: Text("Most & Least Expensive")) {
                    if let maxFish = mostExpensiveFish {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Most Expensive: \(maxFish.getName())")
                                .font(.headline)
                            Text("Price: $\(String(format: "%.2f", maxFish.getPrice()))")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if let minFish = cheapestFish {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Least Expensive: \(minFish.getName())")
                                .font(.headline)
                            Text("Price: $\(String(format: "%.2f", minFish.getPrice()))")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Statistics")
        }
    }
}

// Helper Subview for Statistics
struct StatisticRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .padding(.vertical, 4)
    }
}
