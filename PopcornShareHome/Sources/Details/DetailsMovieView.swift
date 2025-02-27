//
//  DetailsMovieView.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 31/08/24.
//

import SwiftUI
import PopcornShareUtilities
import PopcornShareNetworkModel

public struct DetailsMovieView: View {
    @ObservedObject var viewModel: DetailsMovieViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    public init(viewModel: DetailsMovieViewModel) {
        self._viewModel = ObservedObject(initialValue: viewModel) 
    }

    public var body: some View {
        stateView
            .background(Color.Background.yellow)
            .ignoresSafeArea(edges: .top)
            .toolbarVisibility(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar { ToolbarDismissButton() }
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
            
            if let movie = viewModel.movie, let credits = viewModel.credits {
                movieHeaderInfo(movie, credits: credits)
            }
            
            Text(viewModel.movie?.overview ?? .empty)
                .padding(.medium)
        }
    }

    var movieHeader: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                backdropImageView
                    .padding(.medium)

                if let posterImage = viewModel.posterImage {
                    posterImage
                        .resizable()
                        .frame(width: 120, height: 180)
                        .cornerRadius(.medium)
                        .offset(x: 24, y: 70)
                }
            }
            .compositingGroup()
            .shadow(radius: 5)
            
            if let movie = viewModel.movie, let credits = viewModel.credits {
                movieHeaderInfo(movie, credits: credits)
            }
        }
        .background(
            Color.Background.gray,
            in: .rect(cornerRadius: .medium)
        )
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
        if let backdropImage = viewModel.backdropImage {
            backdropImage
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .overlay(gradientOverlay)
        } else {
            loadingView
                .frame(height: 200)
                .hAlignment(.center)
                .background(in: .rect(cornerRadius: .medium))
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
    DetailsMovieView(viewModel: DetailsMovieViewModel(movieId: "1"))
}
