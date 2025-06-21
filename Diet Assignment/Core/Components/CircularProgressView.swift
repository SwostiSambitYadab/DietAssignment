//
//  CircularProgressView.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import SwiftUI

import SwiftUI

struct CircularProgressView: View {
    
    let total: Int
    let completed: Int
    private let lineWidth: CGFloat = 8

    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: lineWidth)

            // Progress Circle
            Circle()
                .trim(from: 0, to: CGFloat(completed)/CGFloat(total))
                .stroke(Color.red, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))

            // Center Text
            VStack(spacing: 2) {
                Text("Status")
                    .font(.dmSansFont(weight: .Regular, size: 10))
                Text("\(completed) of \(total)")
                    .font(.dmSansFont(weight: .Medium, size: 12))
            }
            .foregroundStyle(.appGrayText)
        }
        .frame(width: 64, height: 64)
        .background(.clear)
        .clipShape(Circle())
    }
}

#Preview {
    CircularProgressView(total: 3, completed: 1)
}
