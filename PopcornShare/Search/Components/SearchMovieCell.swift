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
    
    @State var viewDidLoad = true
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
            Color.Background.gray,
            in: .rect(cornerRadius: .large)
        )
        .overlay(alignment: .topTrailing) {
            favoriteButton
        }
        .padding(.horizontal, .medium)
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
