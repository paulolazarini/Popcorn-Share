//
//  MoviesCategory.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 10/02/25.
//

import SwiftUI
import PopcornShareUtilities
import PopcornShareNetwork

protocol MoviesCategoryViewModeling: ObservableObject {
    var movies: [MovieViewData] { get set }
    var networkManager: NetworkManagerType { get }
    var isLoading: Bool { get }
    var page: Int { get set }
    
    var navigationTitle: String { get }
    
    func getMovies() async
}

struct MoviesCategoryView<ViewModel: MoviesCategoryViewModeling & Sendable>: View {
    @ObservedObject var viewModel: ViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @Namespace var animationId
    
    let gridItems = Array(
        repeating: GridItem(spacing: .small),
        count: 2
    )

    var body: some View {
        moviesGridView
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(.black)
                    }
                }
            }
            .background(Color.Background.yellow)
    }
    
    private var moviesGridView: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .vertical,
            didLoadLastCell: fetchNexPage,
            data: $viewModel.movies) { index, movie in
                NavigationLink {
                    DetailsMovieView(viewModel: DetailsMovieViewModel(movie: movie))
                        .navigationTransition(.zoom(sourceID: movie.id, in: animationId))
                } label: {
                    PSMovieCategoryCell(
                        movie: Binding(
                            get: { return movie },
                            set: { viewModel.movies[index] = $0 }
                        ),
                        animationId: animationId,
                        onFavoriteTapped: { movie in }
                    )
                    .padding(.small)
                }
                .id(UUID())
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
