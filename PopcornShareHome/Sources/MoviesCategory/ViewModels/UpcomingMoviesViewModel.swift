//
//  UpcomingMoviesViewModel.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 11/02/25.
//


import SwiftUI
import PopcornShareUtilities
import PopcornShareNetwork

public final class UpcomingMoviesViewModel: MoviesCategoryViewModeling, @unchecked Sendable {
    @Published var movies: [MovieViewData] = []
    @Published var isLoading: Bool = false
    
    var moviesSet: Set<MovieViewData> = []
    var page: Int = 1
    
    let navigationTitle: String = "Upcoming Movies"
    let networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType = NetworkManager()) {
        self.networkManager = networkManager
        
        Task(priority: .high) { await getMovies() }
    }
    
    func getMovies() async {
        guard !isLoading else { return }
        
        isLoading(true)
        defer { isLoading(false) }
        
        let result = await networkManager.getUpcomingMovies(page: page)
        
        switch result {
        case .success(let movies):
            await MainActor.run { [weak self] in
                guard let self else { return }
                
                movies.results.forEach {
                    if !self.moviesSet.map({ $0.id }).contains($0.toMovieViewData.id) {
                        self.moviesSet.insert($0.toMovieViewData)
                        self.movies.append($0.toMovieViewData)
                    }
                }
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func isLoading(_ bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = bool
        }
    }
}
