//
//  UserManagerType.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 05/03/25.
//

import Foundation

public protocol UserManagerType {
    func updateUser(_ user: DBUser) async throws
    func getUser(userId: String) async throws -> DBUser
}
