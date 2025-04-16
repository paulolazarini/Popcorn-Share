//
//  AuthButtonStyle.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 22/01/25.
//

import SwiftUI

struct AuthButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let size: CGSize
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(size: size)
            .font(.title3)
            .foregroundStyle(foregroundColor)
            .bold()
            .shadow(radius: .extraSmall)
            .background(
                backgroundColor
                    .opacity(configuration.isPressed ? 0.8 : 1.0),
                in: .capsule(style: .continuous)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}
