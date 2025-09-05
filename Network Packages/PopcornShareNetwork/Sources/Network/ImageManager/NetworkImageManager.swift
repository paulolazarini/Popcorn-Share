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

public actor NetworkImageManager: NetworkImageManagerType {
    public static let shared = NetworkImageManager()
    
    private let cacheManager = ImageCache()
    private var ongoingTasks: [String: Task<Result<UIImage, RequestError>, Never>] = [:]
    
    private init() {}
    
    public func getMovieImage(using imageUrl: String) async -> Result<UIImage, RequestError> {
        if let image = await cacheManager.image(forKey: imageUrl) {
            return .success(image)
        }
        
        if let ongoingTask = ongoingTasks[imageUrl] {
            return await ongoingTask.value
        }
        
        let task = Task { () -> Result<UIImage, RequestError> in
            defer {
                ongoingTasks[imageUrl] = nil
            }
            
            guard let url = URL(string: imageUrl) else { return .failure(.invalidURL) }
            
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
        
        ongoingTasks[imageUrl] = task
        
        return await task.value
    }
}