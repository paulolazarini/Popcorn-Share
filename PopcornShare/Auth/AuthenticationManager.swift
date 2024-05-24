//
//  AuthenticationManager.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import Foundation
import FirebaseAuth

protocol AuthenticationManagerType {
    func getAuthenticatedUser() throws -> AuthDataResultModel
    func createUser(username: String, email: String, password: String) async throws -> AuthDataResultModel
    func signIn(email: String, password: String) async throws -> AuthDataResultModel
    func signOut() throws
}

final class AuthenticationManager: AuthenticationManagerType {
    
    static let shared = AuthenticationManager()
    
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
        return AuthDataResultModel(
            user: authDataResult.user,
            name: username
        )
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

struct AuthDataResultModel {
    let uid: String
    let email: String?
    var username: String?
    let photoUrl: String?
    
    init(
        user: User,
        name: String
    ) {
        self.uid = user.uid
        self.email = user.email
        self.username = name
        self.photoUrl = user.photoURL?.absoluteString
    }
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.username = user.displayName
        self.photoUrl = user.photoURL?.absoluteString
    }
}
