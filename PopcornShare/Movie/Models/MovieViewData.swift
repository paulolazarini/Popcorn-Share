//
//  MovieViewData.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

//import Foundation
//
//public struct MovieViewData: Hashable, Identifiable, Equatable {
//    public let id: String
//    let title: String
//    let posterPath: String
//    let backdropPath: String
//    let overview: String
//    let releaseDate: String
//    let runtime: String
//    let genres: [Genre]
//    var favorite: Bool
//    var isLoadingFavorite: Bool
//    
//    public init(
//        title: String,
//        id: String,
//        posterPath: String,
//        backdropPath: String,
//        overview: String,
//        releaseDate: String,
//        runtime: String,
//        favorite: Bool,
//        isLoadingFavorite: Bool = false,
//        genres: [Genre]
//    ) {
//        self.title = title
//        self.id = id
//        self.posterPath = posterPath
//        self.backdropPath = backdropPath
//        self.overview = overview
//        self.releaseDate = releaseDate
//        self.runtime = runtime
//        self.favorite = favorite
//        self.genres = genres
//        self.isLoadingFavorite = isLoadingFavorite
//    }
//    
//    public static func == (lhs: MovieViewData, rhs: MovieViewData) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
//
//extension MovieViewData {
//    static func mock() -> MovieViewData {
//        .init(
//            title: "Godzilla x Kong: The New Empire",
//            id: "823464",
//            posterPath: "/z1p34vh7dEOnLDmyCrlUVLuoDzd.jpg",
//            backdropPath: "/z1p34vh7dEOnLDmyCrlUVLuoDzd.jpg",
//            overview: "Following their explosive showdown, Godzilla and Kong must reunite against a colossal undiscovered threat hidden within our world, challenging their very existence – and our own.",
//            releaseDate: "2024-03-27",
//            runtime: "139",
//            favorite: false,
//            genres: []
//        )
//    }
//}
