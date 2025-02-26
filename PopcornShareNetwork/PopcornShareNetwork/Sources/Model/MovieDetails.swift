//
//  MovieDetails.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import Foundation
import PopcornShareUtilities

public struct MovieDetails: Codable, Sendable {
    public let id: Int
    public let title: String?
    public let backdropPath: String?
    public let posterPath: String?
    public let overview: String?
    public let releaseDate: String?
    public let runtime: Int?
    public let genres: [Genre]?
    
    public init(
        id: Int,
        title: String?,
        posterPath: String?,
        backdropPath: String?,
        overview: String?,
        releaseDate: String?,
        runtime: Int?,
        genres: [Genre]?
    ) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.runtime = runtime
        self.genres = genres
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
        case runtime
        case releaseDate = "release_date"
        case genres
    }
}

public struct Genre: Codable, Sendable {
    public let id: Int
    public let name: String
}

public extension MovieDetails {
    var toMovieViewData: MovieViewData {
        MovieViewData(
            title: self.title ?? "",
            id: String(self.id),
            posterPath: self.posterPath ?? "",
            backdropPath: self.backdropPath ?? "",
            overview: self.overview ?? "",
            releaseDate: self.releaseDate ?? "",
            runtime: self.runtime ?? 0,
            favorite: false,
            genres: self.genres?.map { GenreViewData(id: $0.id, name: $0.name) } ?? []
        )
    }
}
