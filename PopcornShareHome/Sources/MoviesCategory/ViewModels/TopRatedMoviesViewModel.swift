//
//  TopRatedMoviesViewModel.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 11/02/25.
//

import SwiftUI
import PopcornShareUtilities
import PopcornShareNetwork

public final class TopRatedMoviesViewModel: MoviesCategoryViewModeling, @unchecked Sendable {
    @Published var movies: [MovieViewData] = []
    
    let navigationTitle: String = "Top Rated"
    
    let networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getMovies(page: Int = 1) async {
        let result = await networkManager.getTopRatedMovies(page: page)
        
        switch result {
        case .success(let movies):
            await MainActor.run { [weak self] in
                self?.movies = movies.results.map(\.toMovieViewData)
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
