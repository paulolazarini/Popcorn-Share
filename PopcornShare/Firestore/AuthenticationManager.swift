//
//  AuthenticationManager.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import Foundation
import PopcornShareFirebase
import PopcornShareUtilities

final class AuthenticationManager: AuthenticationManagerType {
    @MainActor static let shared = AuthenticationManager()
    
    private let authProvider: AuthProviding = FirebaseAuthService()
    
    private init() { }
    
    func currentUser() throws -> AuthDataResultModel {
        try authProvider.getAuthenticatedUser()
    }
    
    func createUser(username: String, email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResultModel = try await authProvider.createUser(
            username: username,
            email: email,
            password: password
        )
        
        try await UserManager.shared.createNewUser(auth: authDataResultModel)
        
        return authDataResultModel
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        try await authProvider.signIn(email: email, password: password)
    }
    
    func signOut() throws {
        try authProvider.signOut()
    }
}
