//
//  DetailsMovieView.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 31/08/24.
//

import SwiftUI
import PopcornShareUtilities
import PopcornShareNetworkModel

struct DetailsMovieView: View {
    @ObservedObject var viewModel: DetailsMovieViewModel
    
    let onDismiss: () -> Void

    var body: some View {
        stateView
            .background(Color.Background.yellow)
            .ignoresSafeArea(edges: .top)
            .navigationBarBackButtonHidden()
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                PSToolbarDismissButton { onDismiss() }
            }
    }

    @ViewBuilder
    var stateView: some View {
        switch viewModel.state {
        case .details:
            detailsView
        case .loading:
            loadingView
        }
    }

    var detailsView: some View {
        ScrollView {
            backdropImageView
            
            VStack(alignment: .leading, spacing: .medium) {
                if let movie = viewModel.movie,
                   let credits = viewModel.credits {
                    movieHeaderInfo(movie, credits: credits)
                }
                
                Text(viewModel.movie?.overview ?? .empty)
            }
            .padding(.horizontal, .medium)
            .frame(width: UIScreen.main.bounds.width)
        }
    }

    func movieHeaderInfo(
        _ movie: MovieViewData,
        credits: CreditsResponse
    ) -> some View {
        VStack(alignment: .leading, spacing: .medium) {
            Text(movie.title)
                .font(.title2)
                .foregroundColor(.primary)
                .bold()
            
            if let director = credits.crew.first(where: { $0.knownForDepartment == "Directing" }) {
                Text("Directed by \(director.name ?? .empty)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Label("\(movie.runtimeString)", systemImage: "clock")
                    .font(.footnote)
                    .foregroundColor(.primary)
                
                Label(movie.releaseDateString ?? .empty, systemImage: "calendar")
                    .font(.footnote)
                    .foregroundColor(.primary)
                
                Label("Not Watched", systemImage: "eye.slash")
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
        }
    }

    @ViewBuilder
    var backdropImageView: some View {
        if let movie = viewModel.movie {
            PSMovieImage(for: movie, type: .backdrop)
                .frame(height: 300)
                .overlay(gradientOverlay)
        }
    }

    var loadingView: some View {
        ProgressView()
            .controlSize(.extraLarge)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var gradientOverlay: some View {
        LinearGradient(
            colors: [
                .Background.yellow,
                .clear
            ],
            startPoint: .bottom,
            endPoint: UnitPoint(x: 0.5, y: 0.3)
        )
    }
}

#Preview {
    DetailsMovieView(viewModel: DetailsMovieViewModel(movieId: "1")) {}
}
