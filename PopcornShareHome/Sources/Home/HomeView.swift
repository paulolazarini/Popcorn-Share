//
//  HomeView.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 28/01/25.
//

import SwiftUI
import PopcornShareUtilities

public struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    public init(viewModel: HomeViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    @Namespace var animationId
    
    private let gridItems = Array(
        repeating: GridItem(spacing: .small),
        count: 1)
    
    public var body: some View {
        NavigationStack {
            ScrollView(
                .vertical,
                showsIndicators: false
            ) {
                homeHeaderView
                
                ForEach(MovieCategory.allCases, id: \.self) { category in
                    makeMovieSection(category)
                }
            }
            .task(priority: .high) {
                await viewModel.fetchMovies()
            }
        }
    }
    
    private var homeHeaderView: some View {
        PSHomeHeader(headerMovies: $viewModel.headerMovies)
    }
    
    private func makeMovieSection(_ category: MovieCategory) -> some View {
        VStack(spacing: .medium) {
            HStack {
                Text(category.title)
                    .font(.title)
                    .bold()
                
                Spacer()
                
                NavigationLink {
                    makeMovieCategoryExpandedGrid(category)
                } label: {
                    Text("See more")
                        .font(.callout)
                        .bold()
                        .foregroundStyle(Color.yellow)
                }
            }
                
            makeMoviesGrid(category)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.large)
    }
        
    @ViewBuilder
    private func makeMovieCategoryExpandedGrid(_ category: MovieCategory) -> some View {
        switch category {
        case .popular:
            MoviesCategoryView(viewModel: PopularMoviesViewModel())
        case .topRated:
            MoviesCategoryView(viewModel: TopRatedMoviesViewModel())
        case .nowPlaying:
            MoviesCategoryView(viewModel: NowPlayingMoviesViewModel())
        case .upcoming:
            MoviesCategoryView(viewModel: UpcomingMoviesViewModel())
        }
    }
    
    @ViewBuilder
    private func makeMoviesGrid(_ category: MovieCategory) -> some View {
        switch category {
        case .popular:
            popularMovieGrid
        case .topRated:
            topRatedMovieGrid
        case .nowPlaying:
            nowPlayingMovieGrid
        case .upcoming:
            upcomingMovieGrid
        }
    }
    
    private var popularMovieGrid: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .horizontal,
            data: $viewModel.popularMovies) { index, _ in
                makeNavigationLink(movie: $viewModel.popularMovies[index])
            }
    }
    
    private var nowPlayingMovieGrid: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .horizontal,
            data: $viewModel.nowPlayingMovies) { index, _ in
                makeNavigationLink(movie: $viewModel.nowPlayingMovies[index])
            }
    }
    
    private var upcomingMovieGrid: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .horizontal,
            data: $viewModel.upcomingMovies) { index, _ in
                makeNavigationLink(movie: $viewModel.upcomingMovies[index])
            }
    }
    
    private var topRatedMovieGrid: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .horizontal,
            data: $viewModel.topRatedMovies) { index, _ in
                makeNavigationLink(movie: $viewModel.topRatedMovies[index])
            }
    }
    
    private func makeNavigationLink(movie: Binding<MovieViewData>) -> some View {
        NavigationLinkToMovieDetails(movie: movie.wrappedValue) {
            PSCardView(
                movie: movie,
                onFavoriteTapped: { movie in }
            )
        }
    }

}

#Preview {
    NavigationView {
        HomeView(viewModel: HomeViewModel())
    }
}
