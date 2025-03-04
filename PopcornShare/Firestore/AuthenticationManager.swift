//
//  AuthenticationManager.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import Foundation
import PopcornShareAuthentication

import FirebaseAuth

final class AuthenticationManager: AuthenticationManagerType {
    
    @MainActor static let shared = AuthenticationManager()
    
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func createUser(
        username: String,
        email: String,
        password: String
    ) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        let authDataResultModel = AuthDataResultModel(
            user: authDataResult.user,
            name: username
        )
        
        try await UserManager.shared.createNewUser(auth: authDataResultModel)
        
        return authDataResultModel
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
