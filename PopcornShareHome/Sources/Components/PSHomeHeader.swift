//
//  PSHomeHeader.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 28/01/25.
//

import SwiftUI
import Combine
import PopcornShareNetwork
import PopcornShareUtilities

struct PSHomeHeader: View {
    
    @Binding var headerMovies: [MovieViewData]
    @State private var images: [String: Image] = [:]

    var body: some View {
        TabView {
            ForEach(headerMovies, id: \.self) { movie in
                buildImage(for: movie)
            }
        }
        .tabViewStyle(.page)
        .frame(height: 182)
        .clipShape(.rect(cornerRadius: .small))
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.yellow
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
        }
        .padding(.horizontal, .medium)
        .onChange(of: headerMovies) { _, movies in
            movies.forEach { movie in
                Task(priority: .high) {
                    await loadImage(for: movie)
                }
            }
        }
    }
    
    @ViewBuilder
    func buildImage(for movie: MovieViewData) -> some View {
        if let image = images[movie.id] {
            image
                .resizable()
                .scaledToFill()
        } else {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    func loadImage(for movie: MovieViewData) async {
        if let image = await getImage(url: movie.backdropPath) {
            await MainActor.run {
                images[movie.id] = image
            }
        }
    }
    
    func getImage(url: String) async -> Image? {
        let result = await NetworkImageManager().getMovieImage(using: .makePosterPath(url))
        
        switch result {
        case .success(let uiImage):
            return Image(uiImage: uiImage)
        case .failure(let error):
            print("Error fetching image: \(error)")
            return nil
        }
    }
}

#Preview {
    ScrollView {
        PSHomeHeader(headerMovies: .constant(
            [.mock(), .mock(), .mock(), .mock(), .mock()]
        ))
    }
}


