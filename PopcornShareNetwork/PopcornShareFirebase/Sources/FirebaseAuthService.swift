//
//  FirebaseAuthService.swift
//  PopcornShareFirebase
//
//  Created by Paulo Lazarini on 05/03/25.
//

import Foundation
import FirebaseAuth

public protocol AuthProviding {
    func getAuthenticatedUser() throws -> AuthDataResultModel
    func createUser(username: String, email: String, password: String) async throws -> AuthDataResultModel
    func signIn(email: String, password: String) async throws -> AuthDataResultModel
    func signOut() throws
}

public final class FirebaseAuthService: AuthProviding {
    
    public init() {}
    
    public func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    public func createUser(
        username: String,
        email: String,
        password: String
    ) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        let authDataResultModel = AuthDataResultModel(
            user: authDataResult.user,
            name: username
        )
        
        return authDataResultModel
    }
    
    public func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    public func signOut() throws {
        try Auth.auth().signOut()
    }
}
