//
//  WatchlistViewModel.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 06/09/25.
//

import SwiftUI
import Combine
import PopcornShareNetwork
import PopcornShareFirebase
import PopcornShareUtilities

@MainActor
public final class WatchlistViewModel: ObservableObject {
    @Published var userWatchlists: [DBWatchlist] = []
    @Published var showingCreateWatchlist = false
    @Published var isWatchlistLoading = false
    @Published var statusMessage: String?
    
    private let watchlistService: WatchlistProviding
    private let movie: MovieViewData
    
    private var currentUser: DBUser?

    public init(watchlistService: WatchlistProviding = FirebaseWatchlistService(), movie: MovieViewData) {
        self.watchlistService = watchlistService
        self.movie = movie
        
        self.setupCurrentUser()
    }
    
    private func setupCurrentUser() {
        do {
            let authUser = try AuthenticationManager.shared.currentUser()
            self.currentUser = DBUser(userId: authUser.uid, username: authUser.username)
        } catch { self.currentUser = nil }
    }
    
    func fetchUserWatchlists() async {
        guard let currentUser = currentUser else { self.statusMessage = "Faça login para ver suas listas."; return }
        isWatchlistLoading = true
        do {
            self.userWatchlists = try await watchlistService.getWatchlistsForUser(userId: currentUser.userId)
        } catch { self.statusMessage = "Erro ao buscar listas." }
        isWatchlistLoading = false
    }
    
    func addMovieTo(watchlist: DBWatchlist, onComplete: @escaping () -> Void) {
        guard let currentUser = currentUser else { return }
        self.statusMessage = "Adicionando a '\(watchlist.name)'..."
        let movieToAdd = createMovieToAdd(currentUser: currentUser)
        Task {
            do {
                try await watchlistService.addMovieToWatchlist(watchlistId: watchlist.id, movie: movieToAdd)
                self.statusMessage = "✅ Adicionado!"
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                onComplete()
            } catch { self.statusMessage = "🚨 Falha ao adicionar." }
        }
    }
    
    func createWatchlist(name: String, description: String?, onComplete: @escaping () -> Void) async {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty, let currentUser = currentUser else { return }
        isWatchlistLoading = true
        do {
            let newWatchlistId = try await watchlistService.createWatchlist(name: trimmedName, description: description, owner: currentUser)
            let movieToAdd = createMovieToAdd(currentUser: currentUser)
            try await watchlistService.addMovieToWatchlist(watchlistId: newWatchlistId, movie: movieToAdd)
            self.statusMessage = "✅ Lista criada e filme adicionado!"
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            onComplete()
        } catch { self.statusMessage = "🚨 Falha ao criar a lista." }
        isWatchlistLoading = false
    }

    private func createMovieToAdd(currentUser: DBUser) -> DBWatchlistMovie {
        let releaseYear: Int?
        let df = DateFormatter(); df.dateFormat = "yyyy-MM-dd"
        if let date = df.date(from: movie.releaseDate) { releaseYear = Calendar.current.component(.year, from: date) } else { releaseYear = nil }
        return DBWatchlistMovie(movieId: movie.id, title: movie.title, posterPath: movie.posterPath, releaseYear: releaseYear, addedAt: Date(), addedBy: currentUser)
    }
}

struct AddToWatchlistView: View {
    @StateObject private var viewModel: WatchlistViewModel
    @Environment(\.dismiss) var dismiss

    init(movie: MovieViewData) {
        _viewModel = StateObject(wrappedValue: WatchlistViewModel(movie: movie))
    }

    var body: some View {
        NavigationView {
            WatchlistSelectorView(viewModel: viewModel, dismissFlow: { dismiss() })
                .navigationTitle("Adicionar à Lista")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } } }
                .sheet(isPresented: $viewModel.showingCreateWatchlist) {
                    CreateWatchlistView(viewModel: viewModel, dismissFlow: { dismiss() })
                }
        }
    }
}

struct WatchlistSelectorView: View {
    @ObservedObject var viewModel: WatchlistViewModel
    let dismissFlow: () -> Void
    
    var body: some View {
        VStack {
            if let status = viewModel.statusMessage { Text(status).font(.headline).padding() }
            
            List {
                Button(action: { viewModel.showingCreateWatchlist = true }) {
                    Label("Nova Lista", systemImage: "plus.square.on.square")
                        .font(.headline.weight(.bold))
                }
                
                if viewModel.isWatchlistLoading && viewModel.userWatchlists.isEmpty {
                    ProgressView().frame(maxWidth: .infinity)
                } else {
                    ForEach(viewModel.userWatchlists) { watchlist in
                        Button(action: { viewModel.addMovieTo(watchlist: watchlist, onComplete: dismissFlow) }) {
                            HStack(spacing: 15) {
                                Image(systemName: "rectangle.stack")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                VStack(alignment: .leading) {
                                    Text(watchlist.name).font(.headline)
                                    Text("\(watchlist.movieCount) filmes").font(.subheadline).foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .foregroundColor(.primary)
        }
        .onAppear { Task { await viewModel.fetchUserWatchlists() } }
    }
}

struct CreateWatchlistView: View {
    @ObservedObject var viewModel: WatchlistViewModel
    @Environment(\.dismiss) var dismiss
    let dismissFlow: () -> Void
    
    @State private var listName: String = ""
    @State private var listDescription: String = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Cancelar") { dismiss() }
                    .padding()
                
                Spacer()
                
                Text("Nova lista")
                    .font(.headline.bold())
                
                Spacer()
                
                Button("") {}
                    .padding()
            }
            
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Nome")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    TextField("Ex: Filmes para o fim de semana", text: $listName)
                        .padding(12)
                        .background(.thinMaterial)
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading) {
                    Text("Descrição")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    TextField("Uma breve descrição da sua lista", text: $listDescription)
                        .padding(12)
                        .background(.thinMaterial)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            Spacer()
            
            if let status = viewModel.statusMessage { Text(status).padding() }
            
            Button {
                Task { await viewModel.createWatchlist(name: listName, description: listDescription, onComplete: dismissFlow) }
            } label: {
                Text("Criar lista")
                    .font(.headline.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(listName.isEmpty ? .gray : .accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(listName.isEmpty || viewModel.isWatchlistLoading)
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

