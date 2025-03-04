//
//  DetailsMovieView.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 31/08/24.
//

import SwiftUI
import PopcornShareUtilities

public struct DetailsMovieView: View {
    @ObservedObject var viewModel: DetailsMovieViewModel

    @State var posterImage: Image?
    @State var backdropImage: Image?
    
    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        ZStack {
            Color.Background.yellow.ignoresSafeArea()
            stateView
        }
        .navigationTitle(viewModel.movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar { PSToolbarDismissButton() }
        .task(priority: .high) {
            await getMovieBackdrop()
            await getMoviePoster()
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
            movieHeader
            
            Text(viewModel.movie.overview)
                .padding()
        }
    }

    var movieHeader: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                backdropImageView
                    .padding(.medium)

                if let posterImage = posterImage {
                    posterImage
                        .resizable()
                        .frame(width: 120, height: 180)
                        .cornerRadius(.medium)
                        .offset(x: 24, y: 70)
                        .shadow(radius: 5)
                }
            }
            
            movieHeaderInfo
        }
        .background(
            Color.Background.gray,
            in: .rect(cornerRadius: .medium)
        )
        .padding(.small)
    }

    var movieHeaderInfo: some View {
        VStack(alignment: .leading, spacing: .medium) {
            Text(viewModel.movie.title)
                .font(.title2)
                .foregroundColor(.primary)
                .bold()

            Text("Directed by \(viewModel.movie.title)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(viewModel.movie.releaseDate)
                .font(.footnote)
                .foregroundColor(.secondary)
            
            HStack {
                Label("\(viewModel.movie.runtime) minutes", systemImage: "clock")
                    .font(.footnote)
                    .foregroundColor(.primary)
                
                Label(viewModel.movie.releaseDate, systemImage: "calendar")
                    .font(.footnote)
                    .foregroundColor(.primary)
                
                Label("Not Watched", systemImage: "eye.slash")
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
        }
        .padding(.medium)
    }

    @ViewBuilder
    var backdropImageView: some View {
        if let backdropImage {
            backdropImage
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipShape(.rect(cornerRadius: .medium))
        } else {
            loadingView
                .frame(height: 200)
                .hAlignment(.center)
                .background(in: .rect(cornerRadius: .medium))
        }
    }

    var loadingView: some View {
        ProgressView()
    }

    func getMoviePoster() async {
//        let result = await NetworkImageManager.getMovieImage(using: .makePosterPath(viewModel.movie.posterPath))
//        
//        switch result {
//        case .success(let image):
//            await MainActor.run {
//                self.posterImage = Image(uiImage: image)
//                viewModel.state = .details
//            }
//        case .failure(let error):
//            print(error)
//        }
    }

    func getMovieBackdrop() async {
//        let result = await NetworkImageManager.getMovieImage(using: .makePosterPath(viewModel.movie.backdropPath))
//        
//        switch result {
//        case .success(let image):
//            await MainActor.run {
//                self.backdropImage = Image(uiImage: image)
//                viewModel.state = .details
//            }
//        case .failure(let error):
//            print(error)
//        }
    }
}

#Preview {
    DetailsMovieView(viewModel: DetailsMovieViewModel(movie: .mock()))
}
