//
//  AuthenticationManagerType.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 05/03/25.
//

import PopcornShareFirebase

public protocol AuthenticationManagerType {
    func currentUser() throws -> AuthDataResultModel
    func createUser(username: String, email: String, password: String) async throws -> AuthDataResultModel
    func signIn(email: String, password: String) async throws -> AuthDataResultModel
    func signOut() throws
}
