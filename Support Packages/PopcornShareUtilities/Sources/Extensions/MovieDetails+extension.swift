//
//  MovieDetails+extension.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 04/03/25.
//

import PopcornShareNetworkModel

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
