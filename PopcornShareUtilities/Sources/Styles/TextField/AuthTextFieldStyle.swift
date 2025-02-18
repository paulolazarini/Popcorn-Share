//
//  AuthTextFieldStyle.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 22/01/25.
//

import SwiftUI

public extension TextFieldStyle where Self == AuthTextFieldStyle {
    static var authTextFieldStyle: AuthTextFieldStyle { .init() }
}

public struct AuthTextFieldStyle: TextFieldStyle {
    @FocusState var focus: Bool
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 55)
            .padding(.horizontal, .medium)
            .autocorrectionDisabled()
            .autocapitalization(.none)
            .focused($focus)
            .background(
                Color.Background.gray,
                in: .rect(cornerRadius: .large)
            )
            .onTapGesture { focus = true }
    }
}
