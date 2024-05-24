//
//  PSHomeButton.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 28/01/25.
//

import SwiftUI
import PopcornShareUtilities

struct PSHomeButton<Content: View>: View {
    let backgroundColor: Color
    @ViewBuilder let content: () -> Content
    let action: () -> Void
    
    init(
        backgroundColor: Color = Color.Custom.yellow,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.content = label
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            content()
        }
        .buttonStyle(
            HomeButtonStyle(
                backgroundColor: backgroundColor,
                foregroundColor: .white
            )
        )
    }
}

#Preview {
    PSHomeButton {
        print("test")
    } label: {
        Text("Test")
    }
    .padding()
}
