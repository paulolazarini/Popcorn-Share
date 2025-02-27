//
//  SearchMovieCell.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 17/02/25.
//

import SwiftUI

import PopcornShareHome
import PopcornShareNetwork
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
        .task(priority: .high) {
            let result = await NetworkImageManager.shared.getMovieImage(using: .makePosterPath(movie.posterPath))
            if case .success(let image) = result {
                await MainActor.run { self.image = Image(uiImage: image) }
            }
        }

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
