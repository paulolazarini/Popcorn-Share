//
//  NowPlayingMoviesViewModel.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 11/02/25.
//

import SwiftUI
import PopcornShareUtilities
import PopcornShareNetwork

public final class NowPlayingMoviesViewModel: MoviesCategoryViewModeling, @unchecked Sendable {
    @Published var movies: [MovieViewData] = []
    
    let navigationTitle: String = "Now Playing Movies"
    let networkManager: NetworkManagerType
    
    var page: Int = 1
    
    init(networkManager: NetworkManagerType = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getMovies() async {
        let result = await networkManager.getNowPlayingMovies(page: page)
        
        switch result {
        case .success(let movies):
            await MainActor.run { [weak self] in
                self?.movies.append(contentsOf: movies.results.map(\.toMovieViewData))
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
