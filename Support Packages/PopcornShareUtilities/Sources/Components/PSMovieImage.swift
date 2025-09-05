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
    
    @StateObject private var loader = ImageLoader()
    private let movie: MovieViewData
    private let type: ImageType
    
    public init(
        for movie: MovieViewData,
        type: ImageType = .poster
    ) {
        self.movie = movie
        self.type = type
    }
    
    public var body: some View {
        content
            .task {
                let path = (type == .poster) ? movie.posterPath : movie.backdropPath
                await loader.load(url: .makePosterPath(path))
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch loader.state {
        case .loading:
            ProgressView()
                .tint(.primary)
                .controlSize(.large)
                
        case .success(let image):
            image
                .resizable()
                .scaledToFill()
            
        case .failure:
            Image(systemName: "photo.fill")
                .resizable()
                .scaledToFit()
                .padding()
                .foregroundColor(.secondary)
                .background(Color.gray.opacity(0.2))
        }
    }
}

@MainActor
final class ImageLoader: ObservableObject {
    enum State {
        case loading
        case success(Image)
        case failure
    }
    
    @Published private(set) var state: State = .loading

    private let imageFetcher: NetworkImageManagerType
    
    init(imageFetcher: NetworkImageManagerType = NetworkImageManager.shared) {
        self.imageFetcher = imageFetcher
    }
    
    func load(url: String) async {
        let result = await imageFetcher.getMovieImage(using: url)
        
        switch result {
        case .success(let uiImage):
            self.state = .success(Image(uiImage: uiImage))
        case .failure:
            self.state = .failure
        }
    }
}
