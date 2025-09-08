//
//  DetailsMovieViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 31/08/24.
//

import SwiftUI
import Combine
import PopcornShareNetwork
import PopcornShareFirebase
import PopcornShareUtilities
import PopcornShareNetworkModel

final class DetailsMovieViewModel: ObservableObject, @unchecked Sendable {
    enum State {
        case loading, details
    }
    
    @Published var state: State = .loading
    @Published var movie: MovieViewData?
    @Published var credits: CreditsResponse?
    @Published var posterImage: Image?
    @Published var backdropImage: Image?
    
    private let serviceManager: NetworkManagerType
    private let navigationEvents: PassthroughSubject<NavigationEvents, Never>
    
    init(
        serviceManager: NetworkManagerType = NetworkManager(),
        watchlistService: WatchlistProviding = FirebaseWatchlistService(),
        navigationEvents: PassthroughSubject<NavigationEvents, Never>,
        movieId: String
    ) {
        self.serviceManager = serviceManager
        self.navigationEvents = navigationEvents
        
        Task {
            try? await fetchAllData(using: movieId)
        }
    }
    
    func didTapAddToWatchlist() {
        guard let movie else { return }
        
        navigationEvents.send(.addWatchlist(movie))
    }
    
    private func fetchAllData(using id: String) async throws {
        try? await fetchMoviesAndCredits(using: id)
        try? await fetchImages(using: id)
    }
    
    private func fetchMoviesAndCredits(using id: String) async throws {
        async let movieResult = getMovie(using: id)
        async let creditsResult = getCredits(using: id)

        let movie = try await movieResult
        let credits = try await creditsResult

        await MainActor.run {
            self.movie = movie
            self.credits = credits
        }
    }
    
    private func fetchImages(using id: String) async throws {
        async let backdropImageResult = getMovieBackdrop()
        async let posterImageResult = getMoviePoster()

        let backdropImage = try await backdropImageResult
        let posterImage = try await posterImageResult

        await MainActor.run {
            self.posterImage = posterImage
            self.backdropImage = backdropImage
            self.state = .details
        }
    }

    private func getMovie(using id: String) async throws -> MovieViewData {
        let result = await self.serviceManager.getMovie(using: id)
        switch result {
        case let .success(movie): return movie.toMovieViewData
        case let .failure(error): throw error
        }
    }
    
    private func getCredits(using id: String) async throws -> CreditsResponse {
        let result = await self.serviceManager.getCredits(using: id)
        switch result {
        case let .success(credits): return credits
        case let .failure(error): throw error
        }
    }
    
    private func getMoviePoster() async throws -> Image {
        let result = await NetworkImageManager.shared.getMovieImage(using: .makePosterPath(movie?.posterPath ?? .empty))
        switch result {
        case .success(let image): return Image(uiImage: image)
        case .failure(let error): throw error
        }
    }
    
    private func getMovieBackdrop() async throws -> Image {
        let result = await NetworkImageManager.shared.getMovieImage(using: .makePosterPath(movie?.backdropPath ?? .empty))
        switch result {
        case .success(let image): return Image(uiImage: image)
        case .failure(let error): throw error
        }
    }
}
