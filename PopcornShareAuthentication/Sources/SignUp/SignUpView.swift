//
//  SignUpView.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import SwiftUI
import PopcornShareUtilities

enum SignUpOption: CaseIterable {
    case facebook, google, apple
    
    var icon: ImageResource {
        switch self {
        case .facebook:
            return .facebookIcon
        case .google:
            return .googleIcon
        case .apple:
            return .appleIcon
        }
    }
}

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.Background.white.ignoresSafeArea()
            
            VStack(spacing: .large) {
                Text("Sign up to PopcornShare")
                    .font(.title)
                    .bold()
                
                signUpOptionsStack
                
                Text("or do via email")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .horizontalDivider
                
                VStack(spacing: .small) {
                    nameTextfield
                    
                    emailTextfield
                    
                    passwordTextfield
                }
                
                createAccountButton
            }
            .padding(.horizontal, .large)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .safeAreaInset(
            edge: .bottom,
            content: footerView
        )
    }
    
    var signUpOptionsStack: some View {
        HStack(spacing: .medium) {
            ForEach(SignUpOption.allCases, id: \.self) { option in
                buildSignUpOptionButton(option)
            }
        }
    }
    
    func buildSignUpOptionButton(_ option: SignUpOption) -> some View  {
        Button {
            viewModel.didSelectSignUpOption(option)
        } label: {
            Image(option.icon)
                .resizable()
                .frame(width: 30, height: 30)
                .scaledToFit()
                .padding(12)
                .background(
                    Color.Background.gray, in: .circle
                )
        }
    }
    
    var nameTextfield: some View {
        PSTextField(
            placeholder: "Username",
            text: $viewModel.name
        )
        .textContentType(.name)
    }
    
    var emailTextfield: some View {
        PSTextField(
            placeholder: "E-mail address",
            text: $viewModel.email
        )
        .textContentType(.emailAddress)
    }
    
    var passwordTextfield: some View {
        PasswordTextField(
            placeholder: "Password",
            password: $viewModel.password
        )
        .textContentType(.password)
    }
    
    var createAccountButton: some View {
        PSButton(
            "Sign up",
            size: CGSize(
                width: 130,
                height: 50
            )
        ) {
            viewModel.signUp()
        }
        .hAlignment(.trailing)
    }
    
    func footerView() -> some View {
        HStack(spacing: .small) {
            Text("Have an account?")
            
            Button("Sign in") {
                dismiss()
            }
        }
        .hAlignment(.leading)
        .padding(.horizontal, .large)
    }
}
