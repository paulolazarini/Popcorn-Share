//
//  Endpoint.swift
//  HTTPRequestTest
//
//  Created by Paulo Lazarini on 21/04/24.
//

import Foundation

public protocol Endpoint {
    var scheme: Scheme { get }
    
    var baseURL: String { get }
    
    var path: String { get }
    
    var parameters: [URLQueryItem] { get }
    
    var method: RequestMethod { get }
    
    var headers: [String: String] { get }
}

public extension Endpoint {
    var scheme: Scheme {
        return .https
    }
}

public enum Scheme: String {
    case https = "https"
    case http = "http"
}

public enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}
