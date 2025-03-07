//
//  SearchView.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 16/02/25.
//

import SwiftUI

import PopcornShareNetwork
import PopcornShareUtilities

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    @FocusState var focus: Bool
    @Namespace var animationId
    
    var body: some View {
        VStack(spacing: .zero) {
            searchTextField
            
            contentView
        }
        .overlay(alignment: .center) { loadingView }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .vAlignment(.top)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .movies:
            moviesGridView
        case .empty:
            notFoundView
        }
    }
    
    private var moviesGridView: some View {
        PSGridView(
            gridItems: [GridItem(spacing: .zero)],
            data: $viewModel.movies) { index, movie in
                SearchMovieCell(
                    movie: Binding(
                        get: { return movie },
                        set: { viewModel.movies[index] = $0 }
                    ),
                    animationId: animationId,
                    onFavoriteTapped: { movie in }
                )
                .onTapGesture {
                    viewModel.didTapMovieCell(movie)
                }
            }
            .id(UUID())
    }
    
    private var loadingView: some View {
        ProgressView()
            .controlSize(.large)
            .foregroundStyle(.black)
            .renderIf(viewModel.isLoading)
    }
    
    private var notFoundView: some View {
        ContentUnavailableView
            .search(text: viewModel.searchText)
    }
    
    private var searchTextField: some View {
        HStack {
            HStack(spacing: .extraSmall) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                
                TextField("", text: $viewModel.searchText)
                    .frame(height: 35)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .focused($focus)
                    .submitLabel(.search)
                    .overlay(alignment: .leading) {
                        if !focus && viewModel.searchText.isEmpty{
                            Text("Search")
                                .foregroundStyle(.gray)
                        }
                    }
            }
            .padding(.horizontal, .small)
            .background(
                .gray.quaternary,
                in: .rect(cornerRadius: .small)
            )
            
            if !viewModel.searchText.isEmpty {
                Button("Cancel") {
                    viewModel.searchText = .empty
                }
            }
        }
        .padding(.horizontal, .medium)
        .padding(.bottom, .small)
        .animation(.spring, value: viewModel.searchText)
        .onTapGesture { focus = true }
    }
    
}

#Preview {
    SearchView(viewModel: SearchViewModel())
}
