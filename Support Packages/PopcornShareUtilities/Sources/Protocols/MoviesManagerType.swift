//
//  MoviesManagerType.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 04/05/25.
//

import SwiftUI

public protocol MoviesManagerType {
    var favoritedMovies: [MovieViewData] { get set }
    
    func toggleFavorite(userId: String, movieId: String) async
    func fetchFavoritedMovie(using id: String) async throws
    func getFavoriteIds(userId: String) async throws
}
