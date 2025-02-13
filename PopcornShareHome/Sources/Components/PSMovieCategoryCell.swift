//
//  PSMovieCategoryCell.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 13/02/25.
//

import SwiftUI
import PopcornShareNetwork
import PopcornShareUtilities

struct PSMovieCategoryCell: View {
    enum Constants {
        static let movieCardHeight: CGFloat = 250
    }
    
    @Binding var movie: MovieViewData
    @State var viewDidLoad = true
    
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
        .task(priority: .high) {
            guard viewDidLoad else { return }
            
            viewDidLoad = false
            
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
                .controlSize(.large)
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
