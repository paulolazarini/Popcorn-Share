//
//  Endpoint.swift
//  HTTPRequestTest
//
//  Created by Paulo Lazarini on 21/04/24.
//

import Foundation

protocol Endpoint {
    var scheme: Scheme { get }
    
    var baseURL: String { get }
    
    var path: String { get }
    
    var parameters: [URLQueryItem] { get }
    
    var method: RequestMethod { get }
}

extension Endpoint {
    var scheme: Scheme {
        return .https
    }
}

enum Scheme: String {
    case https = "https"
    case http = "http"
}

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}
