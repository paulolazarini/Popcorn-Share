//
//  PSCardView.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 28/01/25.
//

import SwiftUI

import PopcornShareNetwork
import PopcornShareUtilities

struct PSCardView: View {
    enum Constants {
        static let movieCardHeight: CGFloat = 200
        static let movieCardWidth: CGFloat = 150
    }
    
    @Binding var movie: MovieViewData
    let animationId: Namespace.ID
    let onFavoriteTapped: (MovieViewData) -> Void
    
    @State var image: Image?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.primaryRed
                
            moviePoster
            
            movieCardFooter
        }
        .frame(
            width: Constants.movieCardWidth,
            height: Constants.movieCardHeight
        )
        .clipShape(.rect(cornerRadius: .medium))
        .overlay(alignment: .topTrailing) {
            favoriteButton
        }
        .task(priority: .high) {
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
    var moviePoster: some View {
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
    
    var movieCardFooter: some View {
        movieTitle
            .padding(.medium)
            .padding(.vertical, .small)
            .background {
                LinearGradient(
                    colors: [
                        Color.black.opacity(0),
                        Color.black
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
    }
    
    var movieTitle: some View {
        Text(movie.title)
            .font(.footnote)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .foregroundStyle(Color.Background.white)
            .frame(maxWidth: .infinity)
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
        .padding(.medium)
    }
}

#Preview {
    @Previewable @Namespace var animationId
    PSCardView(movie: .constant(.mock()), animationId: animationId) { _ in}
}
