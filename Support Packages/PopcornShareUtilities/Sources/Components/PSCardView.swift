//
//  PSCardView.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 28/01/25.
//

import SwiftUI

public struct PSCardView: View {
    enum Constants {
        static let movieCardHeight: CGFloat = 200
        static let movieCardWidth: CGFloat = 150
    }
    
    let movie: MovieViewData
    
    public init(movie: MovieViewData) {
        self.movie = movie
    }
    
    public var body: some View {
        ZStack {
            Color.primaryRed
            
            moviePoster
        }
        .frame(
            width: Constants.movieCardWidth,
            height: Constants.movieCardHeight
        )
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
}

#Preview {
    PSCardView(movie: .mock())
}
