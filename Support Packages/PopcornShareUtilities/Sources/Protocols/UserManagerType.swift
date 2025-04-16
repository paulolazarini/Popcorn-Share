//
//  UserManagerType.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 05/03/25.
//

import PopcornShareFirebase

public protocol UserManagerType {
    func createNewUser(auth: AuthDataResultModel) async throws
    func updateUser(_ user: DBUser) async throws
    func getUser(userId: String) async throws -> DBUser
}
