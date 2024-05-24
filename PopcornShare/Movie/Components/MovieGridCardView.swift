//
//  MovieGridCardView.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import SwiftUI
import PopcornShareUtilities

struct MovieGridCardView: View {
    enum Constants {
        static let movieCardHeight = 310.0
        static let moviePosterHeight = 255.0
        static let movieFooterHeight = 55.0
    }
    
    @State var image: Image?
    
    @Binding var movie: MovieViewData
    let animationId: Namespace.ID
    let onFavoriteTapped: (MovieViewData) -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.primaryRed
            
            VStack(spacing: .zero) {
                moviePoster
                movieCardFooter
            }
        }
        .frame(height: Constants.movieCardHeight)
        .clipShape(.rect(cornerRadius: .medium))
        .task(priority: .high) {
//            let result = await NetworkImageManager.getMovieImage(using: .makePosterPath(movie.posterPath))
//            
//            switch result {
//            case .success(let image):
//                await MainActor.run {
//                    self.image = Image(uiImage: image)
//                }
//            case .failure(let error):
//                print(error)
//            }
        }
    }
    
    @ViewBuilder
    var moviePoster: some View {
        if let image {
            image
                .resizable()
                .scaledToFill()
                .frame(height: Constants.moviePosterHeight)
                .clipped()
        } else {
            ProgressView()
                .tint(.white)
                .scaledToFit()
                .imageScale(.large)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: Constants.moviePosterHeight
                )
        }
    }
    
    var movieCardFooter: some View {
        HStack(alignment: .center) {
            movieTitle
            Spacer()
            favoriteButton
        }
        .padding(.horizontal, .small)
        .frame(height: Constants.movieFooterHeight)
    }
    
    var movieTitle: some View {
        Text(movie.title)
            .font(.footnote)
            .foregroundStyle(Color.Background.yellow)
    }
    
    var favoriteButton: some View {
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
    }
}

#Preview {
    @Previewable @Namespace var animationId
    MovieGridCardView(movie: .constant(.mock()), animationId: animationId) { _ in}
}
