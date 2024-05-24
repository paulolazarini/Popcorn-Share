//
//  LoginView.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 23/05/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color.customBackground.ignoresSafeArea()
                
                VStack(spacing: .medium) {
                    PopcornShareIcon()
                    
                    emailTextfield
                    
                    passwordTextfield
                    
                    buttonStack
                }
                .padding(.horizontal, .large)
            }
        }
    }
    
    var emailTextfield: some View {
        TextField("E-mail", text: $viewModel.email)
            .loginTextfieldStyle
    }
    
    var passwordTextfield: some View {
        ZStack {
            TextField("Password", text: $viewModel.password)
                .loginSecureTextfieldStyle($viewModel.isShowingPassword)
            
            SecureField("Password", text: $viewModel.password)
                .loginSecureTextfieldStyle($viewModel.isShowingPassword)
                .isHidden($viewModel.isShowingPassword)
        }
    }
    
    var buttonStack: some View {
        VStack {
            loginButton
            
            signInButton
        }
    }
    
    var loginButton: some View {
        Button { }
        label: { Text("Login").loginButtonStyle }
    }
    
    var signInButton: some View {
        Button { }
        label: { Text("Sign In").loginButtonStyle }
    }
}

#Preview {
    LoginView(viewModel: .init())
}
