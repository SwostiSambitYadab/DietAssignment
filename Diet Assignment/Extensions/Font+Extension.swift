//
//  Font+Extension.swift
//  Diet Assignment
//
//  Created by Swosti Sambit Yadab on 21/06/25.
//


import SwiftUICore

extension Font {
    static public func dmSansFont(weight: DMSansFontWeight, size: CGFloat) -> Font {
        return .custom(weight.rawValue, size: size)
    }
}

/// Regular = 400
/// Medium = 500
/// Bold = 700
public enum DMSansFontWeight: String {
    case Regular = "DMSans-Regular"
    case Medium = "DMSans-Medium"
    case Bold = "DMSans-Bold"
}
