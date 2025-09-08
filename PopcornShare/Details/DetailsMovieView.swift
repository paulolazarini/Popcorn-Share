//
//  DetailsMovieView.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 31/08/24.
//

import SwiftUI
import Combine
import PopcornShareUtilities
import PopcornShareNetworkModel

struct DetailsMovieView: View {
    @ObservedObject var viewModel: DetailsMovieViewModel
    let onDismiss: () -> Void
    
    var body: some View {
        stateView
            .ignoresSafeArea(edges: .top)
            .navigationBarBackButtonHidden()
            .toolbar { toolbar }
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(Color(UIColor.systemBackground))
                    .padding(.small)
            }
        }
    }
    
    @ViewBuilder
    private var stateView: some View {
        switch viewModel.state {
        case .details: detailsView
        case .loading: loadingView
        }
    }
    
    private var detailsView: some View {
        VStack(spacing: .zero) {
            if let movie = viewModel.movie {
                PSMovieImage(for: movie, type: .backdrop)
                    .blur(radius: .extraSmall, opaque: true)
                    .overlay {
                        PSMovieImage(for: movie, type: .poster)
                            .clipShape(.rect(cornerRadius: .small))
                            .frame(width: 200, height: 300)
                            .offset(y: .small + .extraLarge)
                    }
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: 350
                    )
                    .padding(.bottom)
                
                VStack(alignment: .leading, spacing: .large) {
                    if let credits = viewModel.credits {
                        movieHeaderInfo(movie, credits: credits)
                    }
                    
                    actionButtons
                    
                    VStack(
                        alignment: .leading,
                        spacing: .medium
                    ) {
                        Text("Sinopse")
                            .font(.headline)
                        Text(movie.overview)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.Gray.primary)
                    }
                }
                .padding()
            }
        }
        .vAlignment(.top)
    }
    
    private var actionButtons: some View {
        HStack(spacing: .medium) {
            Button {
                
            } label: {
                Label("Assistir Trailer", systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            Button {
                viewModel.didTapAddToWatchlist()
            } label: {
                Image(systemName: "bookmark")
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            
            Button(action: {}) {
                Image(systemName: "checkmark")
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
        .font(.headline)
    }
    
    @ViewBuilder
    private func movieHeaderInfo(_ movie: MovieViewData, credits: CreditsResponse) -> some View {
        VStack(alignment: .leading, spacing: .small) {
            Text(movie.title)
                .font(.title)
                .bold()
            
            if let director = credits.crew.first(where: { $0.knownForDepartment == "Directing" }) {
                Text("Dirigido por \(director.name ?? .empty)")
                    .font(.subheadline)
                    .foregroundStyle(Color.Gray.primary)
            }
            
            HStack(spacing: .medium) {
                Label(movie.runtimeString, systemImage: "clock")
                Label(movie.releaseDateString, systemImage: "calendar")
            }
            .font(.footnote)
            .padding(.top, .extraSmall)
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .controlSize(.large)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    DetailsMovieView(
        viewModel: .init(navigationEvents: PassthroughSubject<NavigationEvents, Never>(), movieId: "755898")
    ) {}
}
