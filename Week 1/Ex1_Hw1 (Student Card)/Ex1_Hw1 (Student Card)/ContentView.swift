//
//  ContentView.swift
//  StudentCardApp
//
//  Practice Exercise: Build a Student Card
//

import SwiftUI

struct ContentView: View {
    let name = "Trần Thị Hồng Ân"
    let studentID = "SESEIU24033"
    let gpa = 80
    let isActive = true

    var body: some View {
        ZStack {
            GalaxyBackground()

            VStack(spacing: 40) {

                VStack(spacing: 6) {
                    HStack(spacing: 8) {
                        Text("My Partner")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Image(systemName: "sparkles")
                            .foregroundColor(.yellow)
                    }
                    Text("A better me, a brighter tomorrow!")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.top, 40)

                studentCard

                VStack(spacing: 4) {
                    Text("Keep Learning")
                    Text("Keep Growing 💜")
                }
                .font(.callout)
                .foregroundColor(.white.opacity(0.55))

                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }


    private var studentCard: some View {
        HStack(alignment: .top, spacing: 16) {

            // Avatar tròn dùng ZStack: nền gradient + icon SF Symbol
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.purple, Color.blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                    .shadow(color: .purple.opacity(0.6), radius: 10)

                Image("avt")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
            }

            // Thông tin: Name, Student ID, GPA
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)

                HStack(spacing: 6) {
                    Image(systemName: "creditcard.fill")
                        .foregroundColor(.cyan)
                        .font(.caption)
                    Text("Student ID: \(studentID)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.75))
                }

                HStack(spacing: 6) {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.mint)
                        .font(.caption)
                    Text("GPA: \(String(format: "%.1f", gpa))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.75))
                }
            }

            Spacer()

          
            if isActive {
                Text("Active")
                    .font(.caption2)
                    .bold()
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.green.opacity(0.25))
                    .foregroundColor(.green)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(Color.green.opacity(0.6), lineWidth: 1)
                    )
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.08))
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.2
                        )
                )
        )
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .purple.opacity(0.35), radius: 16, y: 8)
    }
}

struct GalaxyBackground: View {

    // Sinh sẵn vị trí "sao" ngẫu nhiên (cố định seed để không đổi mỗi lần render)
    private let stars: [(x: CGFloat, y: CGFloat, size: CGFloat, opacity: Double)] = {
        var generator = SeededGenerator(seed: 42)
        return (0..<80).map { _ in
            (
                x: CGFloat.random(in: 0...1, using: &generator),
                y: CGFloat.random(in: 0...1, using: &generator),
                size: CGFloat.random(in: 1...3, using: &generator),
                opacity: Double.random(in: 0.3...1.0, using: &generator)
            )
        }
    }()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.02, green: 0.02, blue: 0.08),
                        Color(red: 0.05, green: 0.05, blue: 0.20),
                        Color(red: 0.10, green: 0.05, blue: 0.25)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                Circle()
                    .fill(Color.purple.opacity(0.25))
                    .frame(width: 300, height: 300)
                    .blur(radius: 90)
                    .offset(x: -100, y: -200)

                Circle()
                    .fill(Color.blue.opacity(0.25))
                    .frame(width: 260, height: 260)
                    .blur(radius: 90)
                    .offset(x: 120, y: 150)

                ForEach(0..<stars.count, id: \.self) { i in
                    Circle()
                        .fill(Color.white.opacity(stars[i].opacity))
                        .frame(width: stars[i].size, height: stars[i].size)
                        .position(
                            x: stars[i].x * geo.size.width,
                            y: stars[i].y * geo.size.height
                        )
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { self.state = seed }
    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}


#Preview {
    ContentView()
}
