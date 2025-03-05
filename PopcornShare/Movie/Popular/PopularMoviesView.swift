//
//  PopularMoviesView.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import SwiftUI
import PopcornShareUtilities

struct PopularMoviesView: View {
    @ObservedObject var moviesManager = MoviesManager.shared
    @ObservedObject var viewModel: PopularMoviesViewModel
    
    var body: some View {
        stateView
            .navigationTitle("Popular Movies")
            .onAppear {
                viewModel.getPopularMovies()
            }
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .isLoading(viewModel.isLoading)
    }
    
    @ViewBuilder
    var stateView: some View {
        switch viewModel.state {
        case .movies:
            movieGrid
        case .empty:
            emptyView
        }
    }
    
    var movieGrid: some View {
        MoviesGridView(
            movies: $moviesManager.popularMovies,
            onScrollReachBottom: { viewModel.getPopularMovies() },
            onFavoriteTapped: viewModel.onFavoriteTapped,
            refresh: {}
        )
    }
    
    @ViewBuilder
    var emptyView: some View {
        if viewModel.searchText.isEmpty {
            VStack(spacing: .zero) {
                ContentUnavailableView(
                    "Could not fetch movies.",
                    systemImage: "exclamationmark.circle"
                )
                
                Button("Try again") { }
            }
            .fixedSize()
        } else {
            ContentUnavailableView
                .search(text: viewModel.searchText)
        }
        
    }
}

#Preview {
    NavigationView {
        PopularMoviesView(viewModel: PopularMoviesViewModel())
    }
}
