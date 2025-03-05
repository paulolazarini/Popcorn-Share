//
//  FavoriteMoviesView.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 29/05/24.
//

import SwiftUI

struct FavoriteMoviesView: View {
    @StateObject var moviesManager = MoviesManager.shared
    @ObservedObject var viewModel: FavoriteMoviesViewModel
    
    var body: some View {
        stateView
            .navigationTitle("Favorite Movies")
            .onAppear {
                viewModel.getFavoriteMovies()
            }
            .searchable(text: $viewModel.searchText)
            .isLoading(viewModel.isLoading)
    }
    
    @ViewBuilder
    var stateView: some View {
        switch viewModel.state {
        case .movies:
            movieGrid
        case .loading:
            loadingView
        case .empty:
            emptyView
        case .notFound:
            notFoundView
        }
    }
    
    var movieGrid: some View {
        MoviesGridView(
            movies: $moviesManager.favoritedMovies,
            onFavoriteTapped: viewModel.onFavoriteTapped,
            refresh: {}
        )
    }
    
    var loadingView: some View {
        ProgressView()
    }
    
    var emptyView: some View {
        ContentUnavailableView(
            "No favorite movies yet.",
            systemImage: "heart.slash.fill",
            description: Text("Your favorite movies will appear here.")
        )
    }
    
    var notFoundView: some View {
        ContentUnavailableView
            .search(text: viewModel.searchText)
    }
}

#Preview {
    FavoriteMoviesView(viewModel: FavoriteMoviesViewModel())
}
