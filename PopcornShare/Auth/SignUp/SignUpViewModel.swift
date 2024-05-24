//
//  SignUpViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import SwiftUI

import FirebaseCore
import FirebaseAuth

final class SignUpViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    let authManager: AuthenticationManagerType
    let userManager: UserManagerType
    let dismiss: () -> Void
    
    init(
        authManager: AuthenticationManagerType = AuthenticationManager.shared,
        userManager: UserManagerType = UserManager.shared,
        dismiss: @escaping () -> Void
    ) {
        self.authManager = authManager
        self.userManager = userManager
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
                try await UserManager.shared.createNewUser(auth: userData)
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
