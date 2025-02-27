//
//  NavigationLinkToMovieDetails.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 27/02/25.
//

import SwiftUI
import PopcornShareUtilities

struct NavigationLinkToMovieDetails<Content: View>: View {
    let movie: MovieViewData
    @ViewBuilder let content: () -> Content
    @Namespace var animationId
    
    var body: some View {
        NavigationLink {
            DetailsMovieView(viewModel: DetailsMovieViewModel(movieId: movie.id))
                .navigationTransition(.zoom(sourceID: movie.id, in: animationId))
        } label: {
            content()
        }
        .matchedTransitionSource(id: movie, in: animationId)
        .id(UUID())
    }
}
