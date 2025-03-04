//
//  MovieImage.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 02/03/25.
//

import SwiftUI
import PopcornShareNetwork

public struct PSMovieImage: View {
    public enum ImageType {
        case backdrop, poster
    }
    
    @State var image: Image?
    
    let movie: MovieViewData
    let type: ImageType
    
    public init(for movie: MovieViewData, type: ImageType = .poster) {
        self.movie = movie
        self.type = type
    }
    
    public var body: some View {
        moviePoster
            .task(priority: .utility) {
                guard image == nil else { return }
                
                let path = type == .poster ? movie.posterPath : movie.backdropPath
                let result = await NetworkImageManager.shared.getMovieImage(using: .makePosterPath(path))
                if case .success(let image) = result {
                    await MainActor.run {
                        self.image = Image(uiImage: image)
                    }
                }
            }
    }
}

private extension PSMovieImage {
    @ViewBuilder
    var moviePoster: some View {
        if let image {
            image
                .resizable()
                .scaledToFill()
                .clipped()
        } else {
            ProgressView()
                .tint(.black)
                .scaledToFill()
                .controlSize(.large)
        }
    }
}
