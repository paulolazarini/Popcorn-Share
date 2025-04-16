//
//  SignUpViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import SwiftUI
import PopcornShareUtilities

final class SignUpViewModel: ObservableObject, @unchecked Sendable {
    @Published var name: String = .empty
    @Published var email: String = .empty
    @Published var password: String = .empty
    
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
                let _ = try await authManager.createUser(
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
