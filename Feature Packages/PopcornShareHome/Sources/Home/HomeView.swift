//
//  HomeView.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 28/01/25.
//

import SwiftUI
import PopcornShareUtilities

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    private let gridItems = Array(
        repeating: GridItem(spacing: .small),
        count: 1)
    
    public var body: some View {
        ScrollView(
            .vertical,
            showsIndicators: false
        ) {
            homeCarouselView
            
            ForEach(MovieCategory.allCases, id: \.self) { category in
                makeMovieSection(category)
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .ignoresSafeArea(edges: .top)
    }
    
    private var homeCarouselView: some View {
        HomeCarouselView(headerMovies: $viewModel.headerMovies) { movie in
            viewModel.navigationEvent(.details(movie: movie))
        }
    }
    
    private func makeMovieSection(_ category: MovieCategory) -> some View {
        VStack(spacing: .medium) {
            categoryTitle(category)
                
            makeMoviesGrid(category)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.large)
    }
    
    private func categoryTitle(_ category: MovieCategory) -> some View {
        HStack {
            Text(category.title)
                .font(.title)
                .bold()
            
            Spacer()
            
            Button {
                viewModel.navigationEvent(.seeMore(category))
            } label: {
                Text("See more")
                    .font(.callout)
                    .bold()
                    .foregroundStyle(Color.yellow)
            }
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
                makeCell(for: $viewModel.popularMovies[index])
            }
    }
    
    private var nowPlayingMovieGrid: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .horizontal,
            data: $viewModel.nowPlayingMovies) { index, _ in
                makeCell(for: $viewModel.nowPlayingMovies[index])
            }
    }
    
    private var upcomingMovieGrid: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .horizontal,
            data: $viewModel.upcomingMovies) { index, _ in
                makeCell(for: $viewModel.upcomingMovies[index])
            }
    }
    
    private var topRatedMovieGrid: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .horizontal,
            data: $viewModel.topRatedMovies) { index, _ in
                makeCell(for: $viewModel.topRatedMovies[index])
            }
    }
    
    private func makeCell(for movie: Binding<MovieViewData>) -> some View {
        PSCardView(
            movie: movie,
            onFavoriteTapped: { movie in }
        )
        .onTapGesture {
            viewModel.navigationEvent(.details(movie: movie.wrappedValue))
        }
    }
}
