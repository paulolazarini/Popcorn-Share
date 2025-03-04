//
//  SignUpViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import SwiftUI

import FirebaseCore
import FirebaseAuth

final class SignUpViewModel: ObservableObject, @unchecked Sendable {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    let authManager: AuthenticationManagerType
    let dismiss: () -> Void
    
    init(
        authManager: AuthenticationManagerType,
        dismiss: @escaping () -> Void
    ) {
        self.authManager = authManager
        self.dismiss = dismiss
    }
    
    func signUp() {
        guard !email.isEmpty, !password.isEmpty else {
            print("Future validation for field empty")
            return
        }
        
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let userData = try await authManager.createUser(
                    username: name,
                    email: email,
                    password: password
                )
                
                dismiss()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func didSelectSignUpOption(_ option: SignUpOption) {
        switch option {
        case .facebook:
            print("facebook")
        case .google:
            print("google")
        case .apple:
            print("apple")
        }
    }
}
