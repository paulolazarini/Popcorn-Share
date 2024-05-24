//
//  CacheManager.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 27/08/24.
//

import UIKit

final class CacheManager: @unchecked Sendable {
    
    init() {}

    private let cache = NSCache<NSString, UIImage>()
    private let accessQueue = DispatchQueue(
        label: "com.popcornshare.cacheManager",
        attributes: .concurrent
    )

    func setImage(_ image: UIImage, forKey key: String) async {
        await withCheckedContinuation { continuation in
            accessQueue.async(flags: .barrier) { [weak self] in
                guard let self else { return }
                self.cache.setObject(image, forKey: key as NSString)
                continuation.resume()
            }
        }
    }

    func image(forKey key: String) async -> UIImage? {
        await withCheckedContinuation { continuation in
            accessQueue.async { [weak self] in
                guard let self else {
                    continuation.resume(returning: nil)
                    return
                }
                let image = self.cache.object(forKey: key as NSString)
                continuation.resume(returning: image)
            }
        }
    }

    func removeImage(forKey key: String) {
        accessQueue.async(flags: .barrier) { [weak self] in
            self?.cache.removeObject(forKey: key as NSString)
        }
    }
}
