//
//  PopularMoviesViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import SwiftUI
import Combine

import PopcornShareNetwork
import PopcornShareUtilities

class PopularMoviesViewModel: ObservableObject {
    enum State {
        case movies, empty
    }
    
    @Published var state: State = .movies
    @Published var isLoading = false
    @Published var searchText: String = ""
    
    private let serviceManager: NetworkManagerType
    private let moviesManager: MoviesManager
    private let userId: String
    
    private var cancelSet = Set<AnyCancellable>()
    
    var page: Int = 1
    
    init(
        serviceManager: NetworkManagerType = NetworkManager(),
        moviesManager: MoviesManager = MoviesManager.shared
    ) {
        self.serviceManager = serviceManager
        self.moviesManager = moviesManager
        self.userId = (try? AuthenticationManager.shared.getAuthenticatedUser().uid) ?? .empty
        
        $searchText
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self else { return }
            
                guard !text.isEmpty else {
                    self.page = 1
                    self.moviesManager.popularMovies.removeAll()
                    self.getPopularMovies()
                    return
                }
                
                self.searchMovies(using: text)
            }.store(in: &cancelSet)
    }
    
    func getPopularMovies() {
        guard searchText.isEmpty else { return }
        
        isLoading(true)
        Task {
            do {
                try await moviesManager.getFavoriteIds(userId: userId)
                try await moviesManager.getPopularMovies(page: page)
                page += 1
            } catch {
                print(error.localizedDescription)
            }
            
            isLoading(false)
            await handleState()
        }
    }
    
    func isLoading(_ bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = bool
        }
    }
    
    func onFavoriteTapped(movie: MovieViewData) {
        loading(movie: movie, state: true)
        Task {
            await moviesManager.toogleFavorite(userId: userId, movieId: movie.id)
        }
        loading(movie: movie, state: false)
    }
    
    private func loading(movie: MovieViewData, state: Bool) {
        if let index = moviesManager.popularMovies.firstIndex(where: { $0.id == movie.id }) {
            DispatchQueue.main.async { [weak self] in
                self?.moviesManager.popularMovies[index].isLoadingFavorite = state
            }
        }
    }
    
    private func searchMovies(using query: String) {
        isLoading(true)
        Task { [weak self] in
            guard let self else { return }
            
            let result = await self.serviceManager.searchMovies(using: query)
            
            self.isLoading(false)
            
            switch result {
            case let .success(movies):
                await MainActor.run {
                    self.moviesManager.popularMovies = movies.results.map {
                        $0.toMovieViewData
                    }
                }
                await self.handleState()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    @MainActor
    private func handleState() {
        if self.moviesManager.popularMovies.isEmpty {
            self.state = .empty
            return
        }
        
        self.state = .movies
    }
}
