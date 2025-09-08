//
//  HomeViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 08/09/25.
//

import SwiftUI
import Combine

import PopcornShareUtilities
import PopcornShareNetworkModel
import PopcornShareNetworkCore
import PopcornShareNetwork

public final class HomeViewModel: ObservableObject, @unchecked Sendable {
    @Published var headerMovies: [MovieViewData] = []
    @Published var popularMovies: [MovieViewData] = []
    @Published var topRatedMovies: [MovieViewData] = []
    @Published var upcomingMovies: [MovieViewData] = []
    @Published var nowPlayingMovies: [MovieViewData] = []

    private let userUuid: String
    private let serviceManager: NetworkManagerType
    private let navigationEvents: PassthroughSubject<NavigationEvents, Never>

    init(
        serviceManager: NetworkManagerType = NetworkManager(),
        navigationEvents: PassthroughSubject<NavigationEvents, Never>,
        userUuid: String
    ) {
        self.serviceManager = serviceManager
        self.userUuid = userUuid
        self.navigationEvents = navigationEvents
    }
    
    func navigationEvent(_ event: NavigationEvents) {
        navigationEvents.send(event)
    }
    
    @MainActor
    func fetchMovies() async {
        async let popularMovies = fetchMovies(type: .popular)
        async let topRatedMovies = fetchMovies(type: .topRated)
        async let nowPlayingMovies = fetchMovies(type: .nowPlaying)
        async let upcomingMovies = fetchMovies(type: .upcoming)
        
        let (popular, topRated, nowPlaying, upcoming) = await (
            popularMovies,
            topRatedMovies,
            nowPlayingMovies,
            upcomingMovies
        )
        
        if let popular {
            self.headerMovies = Array(popular.prefix(5))
            self.popularMovies = Array(popular.dropFirst(5))
        }
        
        if let topRated {
            self.topRatedMovies = topRated
        }
        
        if let nowPlaying {
            self.nowPlayingMovies = nowPlaying
        }
        
        if let upcoming {
            self.upcomingMovies = upcoming
        }
    }
    
    private func fetchMovies(
        type: MovieCategory,
        page: Int = 1
    ) async -> [MovieViewData]? {
        let result: Result<Movies, RequestError>
        
        switch type {
        case .popular:
            result = await serviceManager.getPopularMovies(page: page)
        case .topRated:
            result = await serviceManager.getTopRatedMovies(page: page)
        case .nowPlaying:
            result = await serviceManager.getNowPlayingMovies(page: page)
        case .upcoming:
            result = await serviceManager.getUpcomingMovies(page: page)
        }
        
        switch result {
        case .success(let movies):
            return movies.results.map { $0.toMovieViewData }
        case .failure(let error):
            print("Error fetching \(type): \(error)")
            return nil
        }
    }
}
