//
//  HTTPService.swift
//  HTTPRequestTest
//
//  Created by Paulo Lazarini on 16/04/24.
//

import UIKit

protocol HTTPClient {
    func requestModel<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
    func requestModel<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type) async -> Result<T, RequestError> {
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
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let response = response as? HTTPURLResponse else {
                    return .failure(.noResponse)
                }
                switch response.statusCode {
                case 200...299:
                    guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
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
}
