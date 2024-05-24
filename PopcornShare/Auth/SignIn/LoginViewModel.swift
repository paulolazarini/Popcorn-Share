//
//  LoginViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import SwiftUI
import Combine

import FirebaseCore
import FirebaseAuth

class LoginViewModel: ObservableObject {
    enum Events {
        case signUpTapped
        case didSignIn
    }
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    let authManager: AuthenticationManagerType
    
    let events = PassthroughSubject<Events, Never>()
    
    init(
        authManager: AuthenticationManagerType = AuthenticationManager.shared
    ) {
        self.authManager = authManager
    }
    
    func signUpTapped() {
        events.send(.signUpTapped)
    }
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("Future validation for empty field")
            return
        }
        
        Task {
            do {
                let userData = try await authManager.signIn(email: email, password: password)
                print(userData)
                events.send(.didSignIn)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func didSelectSignUpOption(_ option: SignUpOption) { }
}
