//
//  AuthDataResultModel.swift
//  PopcornShareAuthentication
//
//  Created by Paulo Lazarini on 04/03/25.
//

import Foundation
import FirebaseAuth

public struct AuthDataResultModel {
    public let uid: String
    public let email: String?
    public var username: String?
    public let photoUrl: String?
    
    public init(
        user: User,
        name: String
    ) {
        self.uid = user.uid
        self.email = user.email
        self.username = name
        self.photoUrl = user.photoURL?.absoluteString
    }
    
    public init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.username = user.displayName
        self.photoUrl = user.photoURL?.absoluteString
    }
}
