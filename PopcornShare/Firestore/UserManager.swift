//
//  UserManager.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 26/05/24.
//

import Foundation
import PopcornShareFirebase
import PopcornShareUtilities

final class UserManager: UserManagerType {
    @MainActor static let shared = UserManager()
    
    private let authProvider: UserProviding = FirebaseUserService()
    
    private init() {}
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        try await authProvider.createNewUser(auth: auth)
    }
    
    func updateUser(_ user: DBUser) async throws {
        try await authProvider.updateUser(user)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await authProvider.getUser(userId: userId)
    }
}
