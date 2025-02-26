//
//  ServiceRequest.swift
//  HTTPRequestTest
//
//  Created by Paulo Lazarini on 21/04/24.
//

import Foundation
import PopcornShareNetworkCore

enum NetworkRequest {
    case fetchPopularMovies(page: Int)
    case fetchNowPlayingMovies(page: Int)
    case fetchTopRatedMovies(page: Int)
    case fetchUpcomingMovies(page: Int)
    case fetchSearchMovies(query: String)
    case fetchMovie(id: String)
    case fetchCredits(id: String)
}

extension NetworkRequest: Endpoint {
    
    var scheme: Scheme {
        return .https
    }
    
    var baseURL: String {
        return "api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .fetchSearchMovies:
            return "/3/search/movie"
        case .fetchPopularMovies:
            return "/3/movie/popular"
        case .fetchNowPlayingMovies:
            return "/3/movie/now_playing"
        case .fetchTopRatedMovies:
            return "/3/movie/top_rated"
        case .fetchUpcomingMovies:
            return "/3/movie/upcoming"
        case .fetchMovie(let id):
            return "/3/movie/\(id)"
        case .fetchCredits(let id):
            return "/3/movie/\(id)/credits"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case let .fetchPopularMovies(page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case let .fetchNowPlayingMovies(page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case let .fetchTopRatedMovies(page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case let .fetchUpcomingMovies(page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case let .fetchSearchMovies(query):
            return [URLQueryItem(name: "query", value: query)]
        default: return []
        }
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var headers: [String: String] {
        return [
            "Authorization": "Bearer \(MovieAPIKey)",
            "accept": "application/json"
        ]
    }
}

extension NetworkRequest {
    var MovieAPIKey: String {
        if let movieAPIKey = Bundle.main.infoDictionary?["MOVIE_API_KEY"] as? String {
            return movieAPIKey
        }
        
        return .empty
    }
}
