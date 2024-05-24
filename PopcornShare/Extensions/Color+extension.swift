//
//  Color+extension.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 23/05/24.
//

import SwiftUI

extension Color {
    static let customBackground: Color = buildCustomColor(251,245,220)
    static let primaryRed: Color = buildCustomColor(142,1,5)
}

extension Color {
    static func buildCustomColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat = 1.0) -> Color {
        Color(red: red / 255, green: green / 255, blue: blue / 255)
    }
}
