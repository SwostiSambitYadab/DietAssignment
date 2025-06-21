//
//  ScaleButton.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 22/06/25.
//

import Foundation
import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    let scaledAmount: CGFloat
    let duration: CGFloat
    
    init(scaledAmount: CGFloat, duration: CGFloat = 0.25) {
        self.scaledAmount = scaledAmount
        self.duration = duration
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
            .animation(.spring(duration: duration), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ScaleButtonStyle {
    static var scaleButtonStyle: ScaleButtonStyle {
        .init(scaledAmount: 1.2)
    }
}
