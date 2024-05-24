//
//  PasswordTextField.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 22/01/25.
//

import SwiftUI

public struct PasswordTextField: View {
    let placeholder: String
    @Binding var password: String
    @State private var isPasswordVisible: Bool = false
    
    public init(placeholder: String, password: Binding<String>) {
        self.placeholder = placeholder
        self._password = password
    }
    
    public var body: some View {
        passwordTextfield
            .overlay(alignment: .trailing) {
                if !password.isEmpty {
                    showPasswordButton
                }
            }
    }
    
    @ViewBuilder
    var passwordTextfield: some View {
        if isPasswordVisible {
            TextField(placeholder, text: $password)
                .textFieldStyle(AuthTextFieldStyle())
        } else {
            SecureField(placeholder, text: $password)
                .textFieldStyle(AuthTextFieldStyle())
        }
    }
    
    var showPasswordButton: some View {
        Button {
            isPasswordVisible.toggle()
        } label: {
            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                .foregroundColor(.gray)
                .padding(.horizontal, .medium)
        }
    }
}
