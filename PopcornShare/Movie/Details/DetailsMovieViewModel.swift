//
//  DetailsMovieViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 31/08/24.
//

import SwiftUI
import Combine
import PopcornShareUtilities

extension DetailsMovieViewModel {
    enum State {
        case loading, details
    }
}

final class DetailsMovieViewModel: ObservableObject {
    @Published var state: State = .loading
    @Published var movie: MovieViewData
    
    init(
        movie: MovieViewData
    ) {
        self.movie = movie
    }
}
