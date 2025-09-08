//
//  HomeView.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 08/09/25.
//

import SwiftUI
import Combine
import PopcornShareUtilities

enum MovieCategory: CaseIterable {
    case popular, topRated, nowPlaying, upcoming
    
    var title: String {
        switch self {
        case .popular:
            "Populares"
        case .topRated:
            "Melhor avaliados"
        case .nowPlaying:
            "Lançamento"
        case .upcoming:
            "Por vir"
        }
    }
}

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    private let gridItems = Array(
        repeating: GridItem(spacing: .small),
        count: 1)
    
    var body: some View {
        ScrollView {
            HomeCarouselView(headerMovies: viewModel.headerMovies) {
                viewModel.navigationEvent(.movieDetails($0))
            }
            
            ForEach(MovieCategory.allCases, id: \.self) { category in
                makeMovieSection(category)
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .task { await viewModel.fetchMovies() }
    }
    
    private func makeMovieSection(_ category: MovieCategory) -> some View {
        VStack(spacing: .medium) {
            categoryTitle(category)
                
            makeMoviesGrid(category)
        }
        .padding(.horizontal, .large)
    }
    
    private func categoryTitle(_ category: MovieCategory) -> some View {
        HStack {
            Text(category.title)
                .font(.title)
                .bold()
            
            Spacer()
            
            Button {
                viewModel.navigationEvent(.movieList(category))
            } label: {
                Text("Ver mais")
                    .font(.callout)
                    .bold()
                    .foregroundStyle(Color.primaryRed)
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
                makeCell(for: viewModel.popularMovies[index])
            }
    }
    
    private var nowPlayingMovieGrid: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .horizontal,
            data: $viewModel.nowPlayingMovies) { index, _ in
                makeCell(for: viewModel.nowPlayingMovies[index])
            }
    }
    
    private var upcomingMovieGrid: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .horizontal,
            data: $viewModel.upcomingMovies) { index, _ in
                makeCell(for: viewModel.upcomingMovies[index])
            }
    }
    
    private var topRatedMovieGrid: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .horizontal,
            data: $viewModel.topRatedMovies) { index, _ in
                makeCell(for: viewModel.topRatedMovies[index])
            }
    }
    
    private func makeCell(for movie: MovieViewData) -> some View {
        PSCardView(
            movie: movie
        )
        .onTapGesture {
            viewModel.navigationEvent(.movieDetails(movie))
        }
    }
}


#Preview {
    HomeView(viewModel: .init(navigationEvents: PassthroughSubject<NavigationEvents, Never>(), userUuid: .empty))
}
