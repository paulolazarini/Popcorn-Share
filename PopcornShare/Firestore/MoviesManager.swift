//
//  MoviesManager.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import Foundation
import Combine

import PopcornShareNetwork
import PopcornShareUtilities

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol MoviesManagerType: ObservableObject {
    var favoritedMovies: [MovieViewData] { get set }
    
    func toogleFavorite(userId: String, movieId: String) async
    func fetchFavoritedMovie(using id: String) async throws
    func getFavoriteIds(userId: String) async throws
}

final class MoviesManager: MoviesManagerType {
    @Published var favoritedMovies: [MovieViewData] = []
    
    static let shared = MoviesManager()
    
    private let serviceManager: NetworkManagerType = NetworkManager()
    
    private(set) var currentFavoriteMoviesId: Set<String> = []
    
    private init() {}
}

// MARK: - Favorite

extension MoviesManager {
    func getFavoritedMovies() async throws {
        for id in currentFavoriteMoviesId {
            try await fetchFavoritedMovie(using: id)
        }
    }
    
    func getFavoriteIds(userId: String) async throws {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let favoriteIds = snapshot.data()?["favorite_ids"] as? [String] else {
            throw URLError(.badServerResponse)
        }
        
        currentFavoriteMoviesId = Set(favoriteIds)
    }
    
    func fetchFavoritedMovie(using id: String) async throws {
        let result = await self.serviceManager.getMovie(using: id)
        
        switch result {
        case let .success(movie):
            let movie = movie.toMovieViewData
            guard !self.favoritedMovies.contains(movie) else { return }
            
            await MainActor.run {
                self.favoritedMovies.append(movie)
            }
        case let .failure(error):
            throw error
        }
    }
    
    @MainActor
    func toogleFavorite(userId: String, movieId: String) async {
        let userRef = Firestore.firestore().collection("users").document(userId)
        let favorriteMoviesIdArray = Array(currentFavoriteMoviesId)
        
        Task.detached(priority: .background) {
            let dictData = ["favorite_ids": favorriteMoviesIdArray]
            try await userRef.updateData(dictData)
        }
    }
}
