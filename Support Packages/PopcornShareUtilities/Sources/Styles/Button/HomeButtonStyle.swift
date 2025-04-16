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
    
    @State private var isTapped = false
    
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
                    .opacity(configuration.isPressed || isTapped ? 0.8 : 1.0),
                in: .rect(cornerRadius: .medium)
            )
            .scaleEffect(configuration.isPressed || isTapped ? 0.95 : 1.0)
            .animation(.spring(duration: 0.1), value: configuration.isPressed || isTapped)
            .onTapGesture {
                isTapped = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTapped = false
                }
            }
    }
}
