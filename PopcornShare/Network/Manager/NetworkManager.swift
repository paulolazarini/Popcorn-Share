//
//  NetworkManager.swift
//  HTTPRequestTest
//
//  Created by Paulo Lazarini on 21/04/24.
//

import Foundation

protocol NetworkManagerType: HTTPClient {
    func getBooks() async -> Result<[Book], RequestError>
}

struct NetworkManager: NetworkManagerType {
    func getBooks() async -> Result<[Book], RequestError> {
        await requestModel(endpoint: NetworkRequest.getBooks, responseModel: [Book].self)
    }
}
