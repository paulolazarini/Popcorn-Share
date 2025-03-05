//
//  LoginView.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 23/05/24.
//

import SwiftUI
import PopcornShareUtilities

struct LoginView: View {
    enum Constants {
        static let signIn = "Sign in"
        static let signInToPopcornShare = "Sign in to PopcornShare"
        static let orDoViaEmail = "or do via email"
        static let email = "E-mail"
        static let password = "Password"
        static let signUp = "Sign up"
        static let dontHaveAnAccount = "Don't have an account?"
    }
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.Background.white.ignoresSafeArea()
            
            VStack(spacing: .large) {
                popcornShareIcon
                
                Text(Constants.signInToPopcornShare)
                    .font(.title)
                    .bold()
                
                signUpOptionsStack
                
                Text(Constants.orDoViaEmail)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .horizontalDivider
                
                VStack(spacing: .small) {
                    emailTextfield
                    
                    passwordTextfield
                }
                
                loginButton
            }
            .padding(.horizontal, .large)
        }
        .safeAreaInset(
            edge: .bottom,
            content: footerView
        )
    }
    
    var popcornShareIcon: some View {
        PSIcon(
            size: CGSize(
                width: 200,
                height: 200
            )
        )
        .clipShape(.circle)
        .shadow(radius: .small)
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
    
    var emailTextfield: some View {
        PSTextField(
            placeholder: Constants.email,
            text: $viewModel.email
        )
    }
    
    var passwordTextfield: some View {
        PasswordTextField(
            placeholder: Constants.password,
            password: $viewModel.password
        )
    }
    
    var loginButton: some View {
        PSButton(
            Constants.signIn,
            size: CGSize(
                width: 130,
                height: 50
            )
        ) {
            viewModel.signIn()
        }
        .hAlignment(.trailing)
    }
    
    func footerView() -> some View {
        HStack(spacing: .small) {
            Text(Constants.dontHaveAnAccount)
            
            Button(Constants.signUp) {
                viewModel.signUpTapped()
            }
        }
        .hAlignment(.leading)
        .padding(.horizontal, .large)
    }
}
