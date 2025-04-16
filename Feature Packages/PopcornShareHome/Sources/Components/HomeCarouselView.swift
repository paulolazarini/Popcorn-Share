//
//  HomeCarouselView.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 28/01/25.
//

import SwiftUI
import Combine
import PopcornShareNetwork
import PopcornShareUtilities

struct HomeCarouselView: View {
    @Binding var headerMovies: [MovieViewData]
    
    var didTapMovieImage: (MovieViewData) -> Void
    
    var body: some View {
        TabView {
            ForEach(headerMovies, id: \.self) { movie in
                PSMovieImage(for: movie)
                    .overlay {
                        LinearGradient(
                            colors: [.clear, .white],
                            startPoint: .center,
                            endPoint: .bottom)
                    }
                    .onTapGesture {
                        didTapMovieImage(movie)
                    }
            }
        }
        .tabViewStyle(.page)
        .frame(height: 600)
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.yellow
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
        }
    }
}

#Preview {
    ScrollView {
        HomeCarouselView(headerMovies: .constant(
            [.mock(), .mock(), .mock(), .mock(), .mock()]
        )) { _ in }
    }
}


