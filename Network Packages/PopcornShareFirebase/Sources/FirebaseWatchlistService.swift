//
//  DBWatchlist.swift
//  PopcornShareFirebase
//
//  Created by Paulo Lazarini on 05/09/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct DBWatchlist: Identifiable {
    public let id: String
    public let name: String
    public let description: String?
    public let ownerId: String
    public let createdAt: Date?
    public var members: [String: UserRole]
    public var isCollaborative: Bool
    public var movieCount: Int
    public var recentMovies: [RecentMovie]
    
    public enum UserRole: String {
       case owner, editor
    }
    
    public init(
        watchlistId: String,
        name: String,
        description: String?,
        ownerId: String,
        createdAt: Date?,
        members: [String : UserRole],
        isCollaborative: Bool,
        movieCount: Int,
        recentMovies: [RecentMovie]
    ) {
        self.id = watchlistId
        self.name = name
        self.description = description
        self.ownerId = ownerId
        self.createdAt = createdAt
        self.members = members
        self.isCollaborative = isCollaborative
        self.movieCount = movieCount
        self.recentMovies = recentMovies
    }
}

public struct RecentMovie {
    public let movieId: Int
    public let posterPath: String?
    
    public init(
        movieId: Int,
        posterPath: String?
    ) {
        self.movieId = movieId
        self.posterPath = posterPath
    }
}

public struct DBWatchlistMovie {
    public let movieId: String
    public let title: String
    public let posterPath: String?
    public let releaseYear: Int?
    public let addedAt: Date?
    public let addedBy: DBUser
    
    public init(
        movieId: String,
        title: String,
        posterPath: String?,
        releaseYear: Int?,
        addedAt: Date?,
        addedBy: DBUser
    ) {
        self.movieId = movieId
        self.title = title
        self.posterPath = posterPath
        self.releaseYear = releaseYear
        self.addedAt = addedAt
        self.addedBy = addedBy
    }
}

public protocol WatchlistProviding {
    /// Cria uma nova watchlist no Firestore.
    func createWatchlist(name: String, description: String?, owner: DBUser) async throws -> String
    
    /// Adiciona um filme a uma watchlist específica.
    func addMovieToWatchlist(watchlistId: String, movie: DBWatchlistMovie) async throws
    
    /// Remove um filme de uma watchlist.
    func removeMovieFromWatchlist(watchlistId: String, movieId: Int) async throws

    /// Busca todas as watchlists em que um usuário é membro.
    func getWatchlistsForUser(userId: String) async throws -> [DBWatchlist]
    
    /// Busca os detalhes de uma watchlist específica.
    func getWatchlist(watchlistId: String) async throws -> DBWatchlist
    
    /// Busca todos os filmes de uma watchlist.
    func getMoviesForWatchlist(watchlistId: String) async throws -> [DBWatchlistMovie]
    
    /// Adiciona um novo colaborador a uma watchlist.
    func addCollaborator(watchlistId: String, userId: String) async throws
}

public final class FirebaseWatchlistService: WatchlistProviding {
    
    private let watchlistsCollection = Firestore.firestore().collection("watchlists")
    
    public init() {}
    
    public func createWatchlist(name: String, description: String?, owner: DBUser) async throws -> String {
        let newWatchlistRef = watchlistsCollection.document()
        
        let watchlistData: [String: Any] = [
            "name": name,
            "description": description ?? "",
            "ownerId": owner.userId,
            "createdAt": Timestamp(),
            "members": [owner.userId: "owner"],
            "isCollaborative": false,
            "movieCount": 0,
            "recentMovies": []
        ]
        
        try await newWatchlistRef.setData(watchlistData)
        return newWatchlistRef.documentID
    }
    
    public func addMovieToWatchlist(watchlistId: String, movie: DBWatchlistMovie) async throws {
        let watchlistRef = watchlistsCollection.document(watchlistId)
        let movieRef = watchlistRef.collection("movies").document(String(movie.movieId))
        
        let movieData: [String: Any] = [
            "addedAt": Timestamp(),
            "title": movie.title,
            "posterPath": movie.posterPath ?? "",
            "releaseYear": movie.releaseYear ?? 0,
            "addedBy": [
                "userId": movie.addedBy.userId,
                "username": movie.addedBy.username ?? "",
                "photoUrl": movie.addedBy.photoUrl ?? ""
            ]
        ]
        
        let recentMovieData: [String: Any] = [
            "movieId": movie.movieId,
            "posterPath": movie.posterPath ?? ""
        ]
        
        try await Firestore.firestore().runTransaction { (transaction, errorPointer) -> Any? in
            transaction.setData(movieData, forDocument: movieRef)
            
            transaction.updateData([
                "movieCount": FieldValue.increment(Int64(1)),
                "recentMovies": FieldValue.arrayUnion([recentMovieData])
            ], forDocument: watchlistRef)
            
            return nil
        }
    }
    
    public func removeMovieFromWatchlist(watchlistId: String, movieId: Int) async throws {
        let watchlistRef = watchlistsCollection.document(watchlistId)
        let movieRef = watchlistRef.collection("movies").document(String(movieId))
        
        try await Firestore.firestore().runTransaction { (transaction, errorPointer) -> Any? in
            transaction.deleteDocument(movieRef)
            
            transaction.updateData([
                "movieCount": FieldValue.increment(Int64(-1))
            ], forDocument: watchlistRef)
            
            return nil
        }
    }

    public func getWatchlistsForUser(userId: String) async throws -> [DBWatchlist] {
        let query = watchlistsCollection
            .whereField("members.\(userId)", in: ["owner", "editor"])
        
        let snapshot = try await query.getDocuments()
        
        return try snapshot.documents.map { doc -> DBWatchlist in
            let data = doc.data()
            
            let watchlistId = doc.documentID
            let name = data["name"] as? String ?? ""
            let description = data["description"] as? String
            let ownerId = data["ownerId"] as? String ?? ""
            let createdAt = (data["createdAt"] as? Timestamp)?.dateValue()
            let members = data["members"] as? [String: DBWatchlist.UserRole] ?? [:]
            let isCollaborative = data["isCollaborative"] as? Bool ?? false
            let movieCount = data["movieCount"] as? Int ?? 0
            
            let recentMoviesData = data["recentMovies"] as? [[String: Any]] ?? []
            let recentMovies = recentMoviesData.map { movieData -> RecentMovie in
                return RecentMovie(
                    movieId: movieData["movieId"] as? Int ?? 0,
                    posterPath: movieData["posterPath"] as? String
                )
            }
            
            return DBWatchlist(
                watchlistId: watchlistId,
                name: name,
                description: description,
                ownerId: ownerId,
                createdAt: createdAt,
                members: members,
                isCollaborative: isCollaborative,
                movieCount: movieCount,
                recentMovies: recentMovies
            )
        }
    }
    
    public func getWatchlist(watchlistId: String) async throws -> DBWatchlist {
        let snapshot = try await watchlistsCollection.document(watchlistId).getDocument()
        guard let data = snapshot.data() else {
            throw URLError(.badServerResponse)
        }
        
        let name = data["name"] as? String ?? ""
        let description = data["description"] as? String
        let ownerId = data["ownerId"] as? String ?? ""
        let createdAt = (data["createdAt"] as? Timestamp)?.dateValue()
        let members = data["members"] as? [String: DBWatchlist.UserRole] ?? [:]
        let isCollaborative = data["isCollaborative"] as? Bool ?? false
        let movieCount = data["movieCount"] as? Int ?? 0
        
        let recentMoviesData = data["recentMovies"] as? [[String: Any]] ?? []
        let recentMovies = recentMoviesData.map { movieData -> RecentMovie in
            return RecentMovie(
                movieId: movieData["movieId"] as? Int ?? 0,
                posterPath: movieData["posterPath"] as? String
            )
        }
            
        return DBWatchlist(
            watchlistId: snapshot.documentID,
            name: name,
            description: description,
            ownerId: ownerId,
            createdAt: createdAt,
            members: members,
            isCollaborative: isCollaborative,
            movieCount: movieCount,
            recentMovies: recentMovies
        )
    }

    public func getMoviesForWatchlist(watchlistId: String) async throws -> [DBWatchlistMovie] {
        let snapshot = try await watchlistsCollection.document(watchlistId).collection("movies").getDocuments()
        
        return try snapshot.documents.map { doc -> DBWatchlistMovie in
            let data = doc.data()
            let movieId = doc.documentID
            
            let title = data["title"] as? String ?? "Título não encontrado"
            let posterPath = data["posterPath"] as? String
            let releaseYear = data["releaseYear"] as? Int
            let addedAt = (data["addedAt"] as? Timestamp)?.dateValue()
            
            let addedByData = data["addedBy"] as? [String: Any] ?? [:]
            let addedBy = DBUser(
                userId: addedByData["userId"] as? String ?? "",
                photoUrl: addedByData["photoUrl"] as? String,
                username: addedByData["username"] as? String
            )
            
            return DBWatchlistMovie(
                movieId: movieId,
                title: title,
                posterPath: posterPath,
                releaseYear: releaseYear,
                addedAt: addedAt,
                addedBy: addedBy
            )
        }
    }
    
    public func addCollaborator(watchlistId: String, userId: String) async throws {
        try await watchlistsCollection.document(watchlistId).updateData([
            "members.\(userId)": "editor",
            "isCollaborative": true
        ])
    }
}

