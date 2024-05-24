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
    var popularMovies: [MovieViewData] { get set }
    
    func toogleFavorite(userId: String, movieId: String) async
    func getPopularMovies(page: Int) async throws
    func fetchFavoritedMovie(using id: String) async throws
    func getFavoriteIds(userId: String) async throws
}

final class MoviesManager: MoviesManagerType {
    @Published var favoritedMovies: [MovieViewData] = []
    @Published var popularMovies: [MovieViewData] = []
    
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
        
        if currentFavoriteMoviesId.contains(movieId) {
            currentFavoriteMoviesId.remove(movieId)
            
            if let index = favoritedMovies.firstIndex(where: { $0.id == movieId }) {
                favoritedMovies.remove(at: index)
            }
            
            if let index = popularMovies.firstIndex(where: { $0.id == movieId }) {
                popularMovies[index].favorite = false
            }
        } else {
            currentFavoriteMoviesId.insert(movieId)
            
            if let index = popularMovies.firstIndex(where: { $0.id == movieId }) {
                popularMovies[index].favorite = true
            }
        }
        
        let favorriteMoviesIdArray = Array(currentFavoriteMoviesId)
        Task.detached(priority: .background) {
            try await userRef.updateData([
                "favorite_ids": favorriteMoviesIdArray
            ])
        }
    }
}

// MARK: - Popular

extension MoviesManager {
    public func getPopularMovies(page: Int = 1) async throws {
        let result = await self.serviceManager.getPopularMovies(page: page)
        
        switch result {
        case let .success(movies):
            let movies = movies.results.map { $0.toMovieViewData }
            let newMovies = movies.filter { !popularMovies.contains($0) }
            await MainActor.run {
                popularMovies.append(contentsOf: newMovies)
            }
        case let .failure(error):
            throw error
        }
    }
}
