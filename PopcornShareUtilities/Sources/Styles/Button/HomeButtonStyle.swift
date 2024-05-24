//
//  HomeButtonStyle.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 28/01/25.
//

import SwiftUI

public struct HomeButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    
    public init(
        backgroundColor: Color,
        foregroundColor: Color
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: 48)
            .font(.title3)
            .bold()
            .foregroundStyle(foregroundColor)
            .shadow(radius: .extraSmall)
            .background(
                backgroundColor
                    .opacity(configuration.isPressed ? 0.8 : 1.0),
                in: .rect(cornerRadius: .medium)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(
                .spring(response: 0.3, dampingFraction: 0.5),
                value: configuration.isPressed
            )
    }
}
