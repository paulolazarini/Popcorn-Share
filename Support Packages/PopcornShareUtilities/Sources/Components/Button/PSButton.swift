//
//  AuthButton.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 22/01/25.
//

import SwiftUI

public struct PSButton: View {
    let backgroundColor: Color
    let foregroundColor: Color
    let size: CGSize
    let title: String
    let buttonAction: () -> Void
    
    public init(
        _ title: String,
        backgroundColor: Color = .blue,
        foregroundColor: Color = .white,
        size: CGSize = CGSize(width: 200, height: 50),
        buttonAction: @escaping () -> Void
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.size = size
        self.title = title
        self.buttonAction = buttonAction
    }
    
    public var body: some View {
        Button(title) {
            buttonAction()
        }
        .buttonStyle(
            AuthButtonStyle(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                size: size
            )
        )
    }
}

#Preview {
    PSButton("Sign up") {}
}

