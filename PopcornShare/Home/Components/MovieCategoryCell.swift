//
//  MovieCategoryCell.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 13/02/25.
//

import SwiftUI

import PopcornShareNetwork
import PopcornShareUtilities

struct MovieCategoryCell: View {
    enum Constants {
        static let movieCardHeight: CGFloat = 250
    }
    
    @Binding var movie: MovieViewData
    
    let onFavoriteTapped: (MovieViewData) -> Void
    
    var body: some View {
        VStack(spacing: .small) {
            moviePoster
            movieTitle
        }
    }
    
    private var moviePoster: some View {
        PSMovieImage(for: movie)
            .frame(height: Constants.movieCardHeight)
            .clipShape(.rect(cornerRadius: .medium))
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
}
