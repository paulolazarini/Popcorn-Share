//
//  MoviesCategory.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 10/02/25.
//

import SwiftUI
import Combine
import PopcornShareUtilities
import PopcornShareNetwork

struct SeeMoreCategoryView: View {
    @ObservedObject var viewModel: SeeMoreCategoryViewModel
    
    let gridItems = Array(
        repeating: GridItem(spacing: .small),
        count: 2
    )

    var body: some View {
        moviesGridView
            .navigationTitle(viewModel.navigationTitle)
            .toolbarVisibility(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .toolbar {
                PSToolbarDismissButton() {
                    viewModel.navigationEvent(.pop)
                }
            }
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
                    viewModel.navigationEvent(.details(movie: movie))
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
