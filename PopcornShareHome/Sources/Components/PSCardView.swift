//
//  PSCardView.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 28/01/25.
//

import SwiftUI
import PopcornShareUtilities

struct PSCardView: View {
    enum Constants {
        static let movieCardHeight: CGFloat = 200
        static let movieCardWidth: CGFloat = 150
    }
    
    @Binding var movie: MovieViewData
    let onFavoriteTapped: (MovieViewData) -> Void
    
    var body: some View {
        ZStack {
            Color.primaryRed
            
            moviePoster
        }
        .frame(
            width: Constants.movieCardWidth,
            height: Constants.movieCardHeight
        )
        .overlay(alignment: .topTrailing) { favoriteButton }
        .overlay(alignment: .bottom) { movieCardFooter }
        .clipShape(.rect(cornerRadius: .medium))
    }
}

private extension PSCardView {
    var moviePoster: some View {
        PSMovieImage(for: movie)
    }
    
    var movieCardFooter: some View {
        movieTitle
            .padding(.medium)
            .padding(.vertical, .small)
            .background {
                LinearGradient(
                    colors: [.clear, .black],
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
