//
//  HTTPService.swift
//  HTTPRequestTest
//
//  Created by Paulo Lazarini on 16/04/24.
//

import UIKit

public protocol HTTPClient {
    func request(endpoint: Endpoint) async -> Result<Void, RequestError>
    func requestModel<T: Decodable>(endpoint: Endpoint) async -> Result<T, RequestError>
}

public extension HTTPClient {
    func requestModel<T: Decodable>(
        endpoint: Endpoint
    ) async -> Result<T, RequestError> {
            var urlComponents = URLComponents()
            urlComponents.scheme = endpoint.scheme.rawValue
            urlComponents.host = endpoint.baseURL
            urlComponents.path = endpoint.path
            urlComponents.queryItems = endpoint.parameters
            
            guard let url = urlComponents.url else {
                return .failure(.invalidURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue
            
            for (key, value) in endpoint.headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let response = response as? HTTPURLResponse else {
                    return .failure(.noResponse)
                }
                switch response.statusCode {
                case 200...299:
                    guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                        return .failure(.decode)
                    }
                    return .success(decodedResponse)
                case 401:
                    return .failure(.unauthorized)
                default:
                    return .failure(.unexpectedStatusCode)
                }
            } catch {
                return .failure(.unknown)
            }
        }
    
    func request(
        endpoint: Endpoint
    ) async -> Result<Void, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme.rawValue
        urlComponents.host = endpoint.baseURL
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.parameters
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        for (key, value) in endpoint.headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                return .success(Void())
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
