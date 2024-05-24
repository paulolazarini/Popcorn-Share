//
//  DetailsMovieViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 31/08/24.
//

import SwiftUI
import Combine
import PopcornShareUtilities

final class DetailsMovieViewModel: ObservableObject {
    enum State {
        case loading, details
    }
    
    @Published var state: State = .loading
    @Published var movie: MovieViewData
    
    init(
        movie: MovieViewData
    ) {
        self.movie = movie
    }
}
