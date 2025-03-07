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
    let navigationEvents: PassthroughSubject<HomeNavigationEvents, Never>
    
    
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
                PSToolbarDismissButton() { dismiss() }
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
                    navigationEvents.send(.details(movie: movie))
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
