//
//  NetworkImageManager.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 27/08/24.
//

import UIKit
import PopcornShareNetworkCore

public protocol NetworkImageManagerType {
    func getMovieImage(using imageUrl: String) async -> Result<UIImage, RequestError>
}

public final class NetworkImageManager: NetworkImageManagerType, Sendable {
    private let cacheManager: CacheManager = CacheManager()
    
    public init() {}
    
    public func getMovieImage(using imageUrl: String) async -> Result<UIImage, RequestError> {
        guard let url = URL(string: imageUrl) else { return .failure(.invalidURL) }
        
        if let image = await cacheManager.image(forKey: imageUrl) {
            return .success(image)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let image = UIImage(data: data) {
                await cacheManager.setImage(image, forKey: imageUrl)
                return .success(image)
            } else {
                return .failure(.invalidImageData)
            }
        } catch {
            return .failure(.networkError(error))
        }
    }
}
