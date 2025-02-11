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
    
    var navigationTitle: String { get }
    
    func getMovies(page: Int) async
}

struct MoviesCategoryView<ViewModel: MoviesCategoryViewModeling>: View {
    @ObservedObject var viewModel: ViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @Namespace var animationId
    
    let gridItems = Array(
        repeating: GridItem(spacing: .small),
        count: 2)

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
            .task(priority: .userInitiated) { [viewModel] in
                await viewModel.getMovies(page: 1)
            }
            
    }
    
    private var moviesGridView: some View {
        PSGridView(
            gridItems: gridItems,
            orientation: .vertical,
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
        }
    }
}

struct PSMovieCategoryCell: View {
    enum Constants {
        static let movieCardHeight: CGFloat = 250
    }
    
    @Binding var movie: MovieViewData
    let animationId: Namespace.ID
    let onFavoriteTapped: (MovieViewData) -> Void
    
    @State var image: Image?
    
    var body: some View {
        VStack(spacing: .small) {
            moviePoster
                .frame(height: Constants.movieCardHeight)
                .clipShape(.rect(cornerRadius: .medium))
            
            movieTitle
        }
        .overlay(alignment: .topTrailing) { favoriteButton }
        .task(priority: .userInitiated) {
            let result = await NetworkImageManager().getMovieImage(using: .makePosterPath(movie.posterPath))
            
            switch result {
            case .success(let image):
                await MainActor.run {
                    self.image = Image(uiImage: image)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @ViewBuilder
    private var moviePoster: some View {
        if let image {
            image
                .resizable()
                .scaledToFill()
                .clipped()
        } else {
            ProgressView()
                .tint(.white)
                .scaledToFill()
                .imageScale(.large)
        }
    }
    
    private var movieTitle: some View {
        Text(movie.title)
            .font(.body)
            .bold()
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
    }
    
    private var favoriteButton: some View {
        Button {
            onFavoriteTapped(movie)
        } label: {
            if movie.isLoadingFavorite {
                ProgressView()
                    .tint(.white)
            } else {
                Image(systemName: movie.favorite ? "heart.fill" : "heart")
                    .foregroundStyle(movie.favorite ? Color.yellow : Color.Background.yellow)
            }
        }
        .padding(.medium)
    }
}


#Preview {
    MoviesCategoryView(viewModel: PopularMoviesViewModel())
}
