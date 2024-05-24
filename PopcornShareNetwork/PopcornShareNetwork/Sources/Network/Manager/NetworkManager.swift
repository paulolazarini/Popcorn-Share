//
//  NetworkManager.swift
//  HTTPRequestTest
//
//  Created by Paulo Lazarini on 21/04/24.
//

import Foundation
import PopcornShareNetworkCore
import PopcornShareNetworkModel

public protocol NetworkManagerType: HTTPClient {
    func getPopularMovies(page: Int) async -> Result<Movies, RequestError>
    func getNowPlayingMovies(page: Int) async -> Result<Movies, RequestError>
    func getTopRatedMovies(page: Int) async -> Result<Movies, RequestError>
    func getUpcomingMovies(page: Int) async -> Result<Movies, RequestError>
    func searchMovies(using query: String) async -> Result<Movies, RequestError>
    func getMovie(using id: String) async -> Result<MovieDetails, RequestError>
}

public struct NetworkManager: NetworkManagerType {
    
    public init() {}
        
    public func searchMovies(using query: String) async -> Result<Movies, RequestError> {
        await requestModel(endpoint: NetworkRequest.fetchSearchMovies(query: query))
    }
    
    public func getMovie(using id: String) async -> Result<MovieDetails, RequestError> {
        await requestModel(endpoint: NetworkRequest.fetchMovie(id: id))
    }
    
    public func getPopularMovies(page: Int)  async -> Result<Movies, RequestError> {
        await requestModel(endpoint: NetworkRequest.fetchPopularMovies(page: page))
    }
    
    public func getNowPlayingMovies(page: Int) async -> Result<Movies, RequestError> {
        await requestModel(endpoint: NetworkRequest.fetchNowPlayingMovies(page: page))
    }
    
    public func getTopRatedMovies(page: Int) async -> Result<Movies, RequestError> {
        await requestModel(endpoint: NetworkRequest.fetchTopRatedMovies(page: page))
    }
    
    public func getUpcomingMovies(page: Int) async -> Result<Movies, RequestError> {
        await requestModel(endpoint: NetworkRequest.fetchUpcomingMovies(page: page))
    }
}
