//
//  View+extension.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import SwiftUI

extension View {
    func isHidden(_ isHidden: Binding<Bool>) -> some View {
        self
            .modifier(IsHidden(isHidden: isHidden))
    }
    
    var loginTextfieldStyle: some View {
        self
            .modifier(LoginTextfieldStyle())
    }
    
    func loginSecureTextfieldStyle(_ isShowingPassword: Binding<Bool>) -> some View {
        self
            .modifier(LoginSecureTextfieldStyle(isShowingPassword: isShowingPassword))
    }
    
    var loginButtonStyle: some View {
        self
            .modifier(LoginButtonStyle())
    }
}

struct LoginTextfieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Capsule(style: .continuous)
                .foregroundStyle(.white)
            
            content
                .padding(.leading, .medium)
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
    }
}

struct LoginButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        Capsule(style: .continuous)
            .frame(maxWidth: 150, maxHeight: 40)
            .overlay {
                content
                    .font(.title3)
                    .foregroundStyle(.white)
                    .bold()
            }
    }
}

struct LoginSecureTextfieldStyle: ViewModifier {
    @Binding var isShowingPassword: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            Capsule(style: .continuous)
                .foregroundStyle(.white)
            
            HStack {
                content
                
                Spacer()
                
                Button {
                    isShowingPassword.toggle()
                } label: {
                    Image(systemName: isShowingPassword ? "eye.slash" : "eye")
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, .medium)
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
    }
}

struct IsHidden: ViewModifier {
    @Binding var isHidden: Bool
    
    func body(content: Content) -> some View {
        if isHidden {
            content
                .hidden()
        } else {
            content
        }
    }
}
