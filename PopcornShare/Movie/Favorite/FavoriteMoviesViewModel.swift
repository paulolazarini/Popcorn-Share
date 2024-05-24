//
//  FavoriteMoviesViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 29/05/24.
//

import SwiftUI
import Combine

import PopcornShareNetwork
import PopcornShareUtilities

class FavoriteMoviesViewModel: ObservableObject {
    @Published var state: State = .movies
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    
    let events = PassthroughSubject<Event, Never>()
    
    private let serviceManager: NetworkManagerType
    private let moviesManager: MoviesManager
    private let userId: String
    
    private var cancelSet = Set<AnyCancellable>()
    private var allMovies = [MovieViewData]()
    
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
                    self.moviesManager.favoritedMovies.removeAll()
                    self.getFavoriteMovies()
                    return
                }
                
                self.searchMovies(using: text)
            }.store(in: &cancelSet)

    }
    
    func getFavoriteMovies() {
        isLoading(true)
        Task {
            do {
                try await moviesManager.getFavoriteIds(userId: userId)
                try await moviesManager.getFavoritedMovies()
                allMovies = moviesManager.favoritedMovies
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
            allMovies.removeAll(where: { $0.id == movie.id })
        }
        loading(movie: movie, state: false)
    }
    
    private func loading(movie: MovieViewData, state: Bool) {
        if let index = moviesManager.favoritedMovies.firstIndex(where: { $0.id == movie.id }) {
            DispatchQueue.main.async { [weak self] in
                self?.moviesManager.favoritedMovies[index].isLoadingFavorite = state
            }
        }
    }
    
    private func searchMovies(using query: String) {
        moviesManager.favoritedMovies = allMovies.filter { $0.title.contains(query) }
        state = moviesManager.favoritedMovies.isEmpty ? .notFound : .movies
    }
   
    @MainActor
    private func handleState() {
        if self.moviesManager.favoritedMovies.isEmpty {
            self.state = .empty
            return
        }
        
        self.state = .movies
    }
}

extension FavoriteMoviesViewModel {
    enum State {
        case movies, loading, empty, notFound
    }
    
    enum Event {
        case onAppear, onDissapear
        case didTapToPresentMovieDetails(movie: MovieViewData)
    }
}
