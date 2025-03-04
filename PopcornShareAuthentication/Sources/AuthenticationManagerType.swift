//
//  AuthenticationManager.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import Foundation

public protocol AuthenticationManagerType: Sendable {
    func getAuthenticatedUser() throws -> AuthDataResultModel
    func createUser(username: String, email: String, password: String) async throws -> AuthDataResultModel
    func signIn(email: String, password: String) async throws -> AuthDataResultModel
    func signOut() throws
}
