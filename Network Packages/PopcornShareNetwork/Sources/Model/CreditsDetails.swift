//
//  CreditsDetails.swift
//  PopcornShareNetwork
//
//  Created by Paulo Lazarini on 26/02/25.
//

import Foundation

public struct CreditsResponse: Codable, Sendable {
    public let id: Int
    public let cast: [Cast]
    public let crew: [Crew]
}

public struct Crew: Codable, Sendable {
    public let id: Int
    public let adult: Bool?
    public let gender: Int?
    public let knownForDepartment: String?
    public let name: String?
    public let originalName: String?
    public let popularity: Double?
    public let profilePath: String?
    public let creditID: String?
    public let department: String?
    public let job: String?

    public init(
        id: Int,
        adult: Bool?,
        gender: Int?,
        knownForDepartment: String?,
        name: String?,
        originalName: String?,
        popularity: Double?,
        profilePath: String?,
        creditID: String?,
        department: String?,
        job: String?
    ) {
        self.id = id
        self.adult = adult
        self.gender = gender
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.creditID = creditID
        self.department = department
        self.job = job
    }

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case creditID = "credit_id"
        case department
        case job
    }
}

public struct Cast: Codable, Sendable {
    public let id: Int
    public let adult: Bool?
    public let gender: Int?
    public let knownForDepartment: String?
    public let name: String?
    public let originalName: String?
    public let popularity: Double?
    public let profilePath: String?
    public let castID: Int?
    public let character: String?
    public let creditID: String?
    public let order: Int?

    public init(
        id: Int,
        adult: Bool?,
        gender: Int?,
        knownForDepartment: String?,
        name: String?,
        originalName: String?,
        popularity: Double?,
        profilePath: String?,
        castID: Int?,
        character: String?,
        creditID: String?,
        order: Int?
    ) {
        self.id = id
        self.adult = adult
        self.gender = gender
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.castID = castID
        self.character = character
        self.creditID = creditID
        self.order = order
    }

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order
    }
}
