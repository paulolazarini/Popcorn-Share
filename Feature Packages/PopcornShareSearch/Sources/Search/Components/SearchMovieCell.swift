//
//  SearchMovieCell.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 17/02/25.
//

import SwiftUI
import PopcornShareUtilities

struct SearchMovieCell: View {
    @Binding var movie: MovieViewData
    @State var image: Image?
    
    let animationId: Namespace.ID
    let onFavoriteTapped: (MovieViewData) -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            moviePoster
                .frame(width: 70, height: 100)
                .clipShape(.rect(cornerRadius: .medium))
            
            movieInfoView
        }
        .frame(height: 130)
        .padding(.horizontal, .medium)
        .background(
            .gray.quaternary,
            in: .rect(cornerRadius: .small)
        )
        .overlay(alignment: .topTrailing) {
            favoriteButton
        }
        .padding(.horizontal, .medium)
    }
    
    private var movieInfoView: some View {
        VStack {
            movieTitle
            
            Text(movie.releaseDateString ?? .empty)
                .font(.footnote)
                .foregroundColor(.secondary)
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
    
    @ViewBuilder
    private var moviePoster: some View {
        PSMovieImage(for: movie)
    }
    
    private var favoriteButton: some View {
        Button {
            onFavoriteTapped(movie)
        } label: {
            if movie.isLoadingFavorite {
                ProgressView()
                    .tint(.white)
            } else {
                Image(systemName: "heart.fill")
                    .imageScale(.large)
                    .foregroundStyle(movie.favorite ? Color.Background.yellow : Color.white)
            }
        }
        .padding(.medium)
    }
}
