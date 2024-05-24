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
    
    let gridItems = Array(
        repeating: GridItem(spacing: .small),
        count: 1)
    
    public var body: some View {
        NavigationStack {
            ScrollView(
                .vertical,
                showsIndicators: false
            ) {
                homeHeaderView
                
                makeMovieSection("Popular Movies") { popularMovieGrid }
                
                makeMovieSection("Now Playing") { nowPlayingMovieGrid }
                
                makeMovieSection("Top Rated") { topRatedMovieGrid }
                
                makeMovieSection("Upcoming") { upcomingMovieGrid }
            }
            .ignoresSafeArea(edges: .top)
            .task(priority: .userInitiated) {
                async let popularMovies: () = viewModel.getPopularMovies()
                async let topRatedMovies: () = viewModel.getTopRatedMovies()
                async let nowPlayingMovies: () = viewModel.getNowPlayingMovies()
                async let upcomingMovies: () = viewModel.getUpcomingMovies()
                
                let _ = await (
                    popularMovies,
                    upcomingMovies,
                    topRatedMovies,
                    nowPlayingMovies
                )
            }
        }
    }
    
    var homeHeaderView: some View {
        PSHomeHeader(headerMovies: $viewModel.headerMovies)
            .overlay(alignment: .bottom) {
                HStack(spacing: .medium) {
                    PSHomeButton(backgroundColor: Color.Custom.gray) {
                        print("test")
                    } label: {
                        Label(
                            "Wishlist",
                            systemImage: "plus"
                        )
                    }
                    
                    PSHomeButton {
                        print("test")
                    } label: {
                        Text("Details")
                    }
                }
                .padding(.bottom, 55)
                .padding(.horizontal, .large)
            }
    }
    
    var popularMovieGrid: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .horizontal,
            data: $viewModel.popularMovies) { index, movie in
                NavigationLink {
                    DetailsMovieView(viewModel: DetailsMovieViewModel(movie: movie))
                        .navigationTransition(.zoom(sourceID: movie.id, in: animationId))
                } label: {
                    PSCardView(
                        movie: Binding(
                            get: { return movie },
                            set: { viewModel.popularMovies[index] = $0 }
                        ),
                        animationId: animationId,
                        onFavoriteTapped: { movie in }
                    )
                }
            }
    }
    
    var nowPlayingMovieGrid: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .horizontal,
            data: $viewModel.nowPlayingMovies) { index, movie in
                NavigationLink {
                    DetailsMovieView(viewModel: DetailsMovieViewModel(movie: movie))
                        .navigationTransition(.zoom(sourceID: movie.id, in: animationId))
                } label: {
                    PSCardView(
                        movie: Binding(
                            get: { return movie },
                            set: { viewModel.nowPlayingMovies[index] = $0 }
                        ),
                        animationId: animationId,
                        onFavoriteTapped: { movie in }
                    )
                }
            }
    }
    
    var upcomingMovieGrid: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .horizontal,
            data: $viewModel.upcomingMovies) { index, movie in
                NavigationLink {
                    DetailsMovieView(viewModel: DetailsMovieViewModel(movie: movie))
                        .navigationTransition(.zoom(sourceID: movie.id, in: animationId))
                } label: {
                    PSCardView(
                        movie: Binding(
                            get: { return movie },
                            set: { viewModel.upcomingMovies[index] = $0 }
                        ),
                        animationId: animationId,
                        onFavoriteTapped: { movie in }
                    )
                }
            }
    }
    
    var topRatedMovieGrid: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .horizontal,
            data: $viewModel.topRatedMovies) { index, movie in
                NavigationLink {
                    DetailsMovieView(viewModel: DetailsMovieViewModel(movie: movie))
                        .navigationTransition(.zoom(sourceID: movie.id, in: animationId))
                } label: {
                    PSCardView(
                        movie: Binding(
                            get: { return movie },
                            set: { viewModel.topRatedMovies[index] = $0 }
                        ),
                        animationId: animationId,
                        onFavoriteTapped: { movie in }
                    )
                }
            }
    }
    
    func makeMovieSection(
        _ title: String,
        @ViewBuilder _ content: () -> some View
    ) -> some View {
        VStack(spacing: .medium) {
            HStack {
                Text(title)
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("See more")
                        .font(.callout)
                        .bold()
                        .foregroundStyle(Color.yellow)
                }
            }
                
            content()
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.large)
    }
}

#Preview {
    NavigationView {
        HomeView(viewModel: HomeViewModel())
    }
}
