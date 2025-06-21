//
//  AppButton.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//

import SwiftUI

struct AppButton: View {
    
    var icon: ImageResource? = nil
    let title: String
    let hasBorder: Bool
    let color: Color
    let font: Font
    let fontColor: Color
    var height: CGFloat = 28
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 4) {
            if let icon {
                Image(icon)
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            Text(title)
                .font(font)
                .foregroundStyle(fontColor)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .background(
            Capsule()
                .fill(hasBorder ? .clear : color)
                .stroke(hasBorder ? color : .clear, lineWidth: 1)
        )
        .onTapGesture {
            onTap?()
        }
    }
}

#Preview {
    AppButton(
        icon: .customize,
        title: "Customize",
        hasBorder: false,
        color: .appBlue,
        font: .dmSansFont(weight: .Bold, size: 12),
        fontColor: .white
    )
}

#Preview {
    // For template images can use foreground style modifier
    AppButton(
        icon: .checkSelected,
        title: "Fed",
        hasBorder: true,
        color: .appGrayText,
        font: .dmSansFont(weight: .Regular, size: 12),
        fontColor: .appGrayText
    )
    .foregroundStyle(.appBlue)
}

#Preview {
    AppButton(
        title: "Customize",
        hasBorder: false,
        color: .appBlue,
        font: .dmSansFont(weight: .Bold, size: 12),
        fontColor: .white
    )
}
