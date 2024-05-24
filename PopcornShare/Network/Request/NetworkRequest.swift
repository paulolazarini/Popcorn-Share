//
//  ServiceRequest.swift
//  HTTPRequestTest
//
//  Created by Paulo Lazarini on 21/04/24.
//

import Foundation

enum NetworkRequest {
    case getBooks
}

extension NetworkRequest: Endpoint {
    var scheme: Scheme {
        switch self {
        default:
            return .https
        }
    }
    
    var baseURL: String {
        switch self {
        default:
            return "bit.ly"
        }
    }
    
    var path: String {
        switch self {
        default:
            return "/3sspdFO"
        }
    }
    
    
    var parameters: [URLQueryItem] {
        switch self {
        default:
            return []
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getBooks:
            return .get
        }
    }
}
