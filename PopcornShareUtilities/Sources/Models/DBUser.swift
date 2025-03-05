//
//  DBUser.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 05/03/25.
//

import Foundation

public struct DBUser: Hashable, Sendable {
    public let userId: String
    public let dateCreated: Date?
    public let dateUpdated: Date?
    public let photoUrl: String?
    public let email: String?
    public let username: String?
    public let city: String?
    public let biography: String?
    public let country: String?
    public let favoriteIds: [String]?
    
    public init(
        userId: String,
        dateCreated: Date? = nil,
        dateUpdated: Date? = nil,
        photoUrl: String? = nil,
        email: String? = nil,
        username: String? = nil,
        city: String? = nil,
        country: String? = nil,
        biography: String? = nil,
        favoriteIds: [String]? = nil
    ) {
        self.userId = userId
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        self.photoUrl = photoUrl
        self.email = email
        self.username = username
        self.city = city
        self.country = country
        self.biography = biography
        self.favoriteIds = favoriteIds
    }
}
