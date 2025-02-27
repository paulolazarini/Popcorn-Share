//
//  CacheManager.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 27/08/24.
//

import UIKit

actor ImageCache {
    private var cache = NSCache<NSString, UIImage>()

    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
