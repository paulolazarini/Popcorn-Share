//
//  SearchViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 16/02/25.
//

import SwiftUI
import Combine

import PopcornShareNetwork
import PopcornShareUtilities

final class SearchViewModel: ObservableObject {
    enum State {
        case movies, empty
    }
    
    @Published var movies: [MovieViewData] = []
    @Published var searchText: String = ""
    @Published var state: State = .movies
    @Published var isLoading = false
    
    private let serviceManager: NetworkManagerType
    
    private var cancelSet = Set<AnyCancellable>()
    
    init(
        serviceManager: NetworkManagerType = NetworkManager()
    ) {
        self.serviceManager = serviceManager
        
        self.getPopularMovies()
        
        $searchText
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self else { return }
                
                guard !text.isEmpty else {
                    self.movies.removeAll()
                    self.getPopularMovies()
                    return
                }
                
                self.searchMovies(using: text)
            }.store(in: &cancelSet)
    }
    
    private func getPopularMovies() {
        isLoading(true)
        Task { [weak self] in
            guard let self else { return }
            
            let result = await self.serviceManager.getPopularMovies(page: 1)
            
            self.isLoading(false)
            
            switch result {
            case .success(let movies):
                await MainActor.run {
                    self.movies = movies.results.map { $0.toMovieViewData }
                }
            case .failure(let error):
                print(error.localizedDescription)
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
                    guard !movies.results.isEmpty else {
                        self.state = .empty
                        return
                    }
                    
                    self.movies = movies.results.map { $0.toMovieViewData }
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func isLoading(_ bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = bool
        }
    }
}
