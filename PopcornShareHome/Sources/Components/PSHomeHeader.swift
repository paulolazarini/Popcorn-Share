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
    
    var body: some View {
        TabView {
            ForEach(headerMovies, id: \.self) { movie in
                NavigationLinkToMovieDetails(movie: movie) {
                    PSMovieImage(for: movie)
                        .overlay {
                            LinearGradient(
                                colors: [.clear, .white],
                                startPoint: .center,
                                endPoint: .bottom)
                        }
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
        PSHomeHeader(headerMovies: .constant(
            [.mock(), .mock(), .mock(), .mock(), .mock()]
        ))
    }
}


