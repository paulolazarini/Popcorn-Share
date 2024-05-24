//
//  HomeViewModel.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 29/01/25.
//

import SwiftUI

import PopcornShareUtilities
import PopcornShareNetwork

public final class HomeViewModel: ObservableObject, @unchecked Sendable {
    @Published var headerMovies: [MovieViewData] = []
    @Published var popularMovies: [MovieViewData] = []
    @Published var topRatedMovies: [MovieViewData] = []
    @Published var upcomingMovies: [MovieViewData] = []
    @Published var nowPlayingMovies: [MovieViewData] = []

    private let serviceManager: NetworkManagerType

    public init(serviceManager: NetworkManagerType = NetworkManager()) {
        self.serviceManager = serviceManager
    }

    func getPopularMovies(page: Int = 1) async {
        let result = await serviceManager.getPopularMovies(page: page)

        switch result {
        case let .success(movies):
            let moviesConverted = movies.results.map { $0.toMovieViewData }
            
            await MainActor.run {
                self.popularMovies = moviesConverted
                self.headerMovies = Array(moviesConverted.prefix(5))
            }
        case let .failure(error):
            print(error)
        }
    }
    
    func getTopRatedMovies(page: Int = 1) async {
        let result = await serviceManager.getTopRatedMovies(page: page)

        switch result {
        case let .success(movies):
            let moviesConverted = movies.results.map { $0.toMovieViewData }
            
            await MainActor.run {
                self.topRatedMovies = moviesConverted
            }
        case let .failure(error):
            print(error)
        }
    }

    func getNowPlayingMovies(page: Int = 1) async {
        let result = await serviceManager.getNowPlayingMovies(page: page)

        switch result {
        case let .success(movies):
            let moviesConverted = movies.results.map { $0.toMovieViewData }
            
            await MainActor.run {
                self.nowPlayingMovies = moviesConverted
            }
        case let .failure(error):
            print(error)
        }
    }

    
    func getUpcomingMovies(page: Int = 1) async {
        let result = await serviceManager.getUpcomingMovies(page: page)

        switch result {
        case let .success(movies):
            let moviesConverted = movies.results.map { $0.toMovieViewData }
            
            await MainActor.run {
                self.upcomingMovies = moviesConverted
            }
        case let .failure(error):
            print(error)
        }
    }

}
