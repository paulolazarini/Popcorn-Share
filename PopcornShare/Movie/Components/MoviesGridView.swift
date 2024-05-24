//
//  MoviesGridView.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import SwiftUI
import PopcornShareUtilities

struct MoviesGridView: View {
    @Binding var movies: [MovieViewData]
    let onFavoriteTapped: (MovieViewData) -> Void
    let onScrollReachBottom: (() -> Void)?
    let refresh: () -> Void
    
    init(
        movies: Binding<[MovieViewData]>,
        onScrollReachBottom: (() -> Void)? = nil,
        onFavoriteTapped: @escaping (MovieViewData) -> Void,
        refresh: @escaping () -> Void
    ) {
        self._movies = movies
        self.onFavoriteTapped = onFavoriteTapped
        self.onScrollReachBottom = onScrollReachBottom
        self.refresh = refresh
    }
    
    @Namespace var animationId
    
    let columns = Array(repeating: GridItem(spacing: .small), count: 2)
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: .small) {
                ForEach($movies, id: \.self) { movie in
                    NavigationLink {
                        let viewModel = DetailsMovieViewModel(
                            movie: movie.wrappedValue
                        )
                        DetailsMovieView(viewModel: viewModel)
                            .navigationTransition(.zoom(sourceID: movie.id, in: animationId))
                    } label: {
                        MovieGridCardView(
                            movie: movie,
                            animationId: animationId,
                            onFavoriteTapped: onFavoriteTapped
                        )
                        
                    }
                }
                
                Color.clear
                    .onAppear { onScrollReachBottom?() }
            }
            .animation(.default, value: movies)
            .padding(.small)
        }
        .refreshable {
            refresh()
        }
    }
}

//#Preview {
//    MoviesGridView(movies: .constant([.mock()])) { _ in } refresh: { }
//}
