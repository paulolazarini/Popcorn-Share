//
//  SeeMoreCategoryViewModel.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 11/02/25.
//

import SwiftUI
import Combine

import PopcornShareUtilities
import PopcornShareNetwork
import PopcornShareNetworkCore
import PopcornShareNetworkModel

public final class SeeMoreCategoryViewModel: ObservableObject, @unchecked Sendable {
    @Published var movies: [MovieViewData] = []
    @Published private(set) var isLoading: Bool = false
    
    var moviesSet: Set<MovieViewData> = []
    var page: Int = 1
    
    let navigationTitle: String
    
    private let type: MovieCategory
    private let networkManager: NetworkManagerType
    private let navigationEvents: PassthroughSubject<HomeNavigationEvents, Never>
    
    init(
        networkManager: NetworkManagerType = NetworkManager(),
        type: MovieCategory,
        navigationEvents: PassthroughSubject<HomeNavigationEvents, Never>
    ) {
        self.networkManager = networkManager
        self.type = type
        self.navigationTitle = type.title
        self.navigationEvents = navigationEvents
        
        Task(priority: .high) {
            await getMovies()
        }
    }
    
    func navigationEvent(_ event: HomeNavigationEvents) {
        navigationEvents.send(event)
    }
    
    func getMovies() async {
        guard !isLoading else { return }
        
        await isLoading(true)
        
        let result = await requestMovies(for: type)
        
        await isLoading(false)
            
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
    
    private func requestMovies(for category: MovieCategory) async -> Result<Movies, RequestError> {
        switch category {
        case .popular:
            return await networkManager.getPopularMovies(page: page)
        case .topRated:
            return await networkManager.getTopRatedMovies(page: page)
        case .nowPlaying:
            return await networkManager.getNowPlayingMovies(page: page)
        case .upcoming:
            return await networkManager.getUpcomingMovies(page: page)
        }
    }
    
    @MainActor
    private func isLoading(_ bool: Bool) {
        self.isLoading = bool
    }
}
