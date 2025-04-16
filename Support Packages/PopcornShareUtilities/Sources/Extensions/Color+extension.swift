//
//  Color+extension.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 23/05/24.
//

import SwiftUI

public extension Color {
    enum Background {
        public static let yellow: Color = buildCustomColor(251,245,220)
        public static let white: Color = buildCustomColor(255,255,255)
        public static let gray: Color = buildCustomColor(240,246,250)
    }
    
    enum Custom {
        public static let yellow: Color = buildCustomColor(242,201,76)
        public static let gray: Color = buildCustomColor(51,51,51)
    }
    
    static let primaryRed: Color = buildCustomColor(142,1,5)
    
    static func buildCustomColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat = 1.0) -> Color {
        Color(red: red / 255, green: green / 255, blue: blue / 255)
    }
}
