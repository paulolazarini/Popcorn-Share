//
//  MovieListView.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 10/02/25.
//

import SwiftUI
import Combine
import PopcornShareUtilities
import PopcornShareNetwork

struct MovieListView: View {
    @ObservedObject var viewModel: MovieListViewModel
    @Environment(\.dismiss) var dismiss
    
    let gridItems = Array(
        repeating: GridItem(spacing: .small),
        count: 2
    )

    var body: some View {
        moviesGridView
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .toolbar { PSToolbarDismissButton() { dismiss() } }
            .background(Color.Background.white)
    }
    
    private var moviesGridView: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .vertical,
            didLoadLastCell: fetchNexPage,
            data: $viewModel.movies) { index, movie in
                MovieCategoryCell(
                    movie: Binding(
                        get: { return movie },
                        set: { viewModel.movies[index] = $0 }
                    ),
                    onFavoriteTapped: { movie in }
                )
                .padding(.small)
                .onTapGesture {
                    viewModel.navigationEvent(.movieDetails(movie))
                }
            }
            .safeAreaInset(edge: .bottom) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.black)
                        .controlSize(.large)
                        .padding(.vertical, .medium)
                }
            }
    }
    
    private func fetchNexPage() {
        Task(priority: .high) {
            viewModel.page += 1
            await viewModel.getMovies()
        }
    }
}
