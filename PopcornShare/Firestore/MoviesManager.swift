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

final class MoviesManager: MoviesManagerType {
    @Published var favoritedMovies: [MovieViewData] = []
    
    static let shared = MoviesManager()
    
    private let serviceManager: NetworkManagerType = NetworkManager()
    
    private(set) var currentFavoriteMoviesId: Set<String> = []
    
    private init() {}
}

// MARK: - Favorite

extension MoviesManager {
    func getFavoritedMovies(userId: String) async throws {
        try await getFavoriteIds(userId: userId)
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            for id in currentFavoriteMoviesId {
                group.addTask {
                    try await self.fetchFavoritedMovie(using: id)
                }
            }

            try await group.waitForAll()
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
    
    func toggleFavorite(userId: String, movieId: String) async {
        let userRef = Firestore.firestore().collection("users").document(userId)
        
        if currentFavoriteMoviesId.contains(movieId) {
            currentFavoriteMoviesId.remove(movieId)
        } else {
            currentFavoriteMoviesId.insert(movieId)
        }

        let updatedFavorites = Array(currentFavoriteMoviesId)
        
        Task {
            let dictData = ["favorite_ids": updatedFavorites]
            try? await userRef.updateData(dictData)
        }
    }
}
