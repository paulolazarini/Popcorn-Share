//
//  TabBarPage.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 17/01/25.
//

import UIKit

enum TabBarPage: Int, CaseIterable {
    case movies = 0
    case favorite = 1
    case profile = 2
    
    var title: String {
        switch self {
        case .movies:
            "Movies"
        case .favorite:
            "Favorites"
        case .profile:
            "Profile"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .movies:
            return UIImage(systemName: "popcorn")
        case .favorite:
            return UIImage(systemName: "heart")
        case .profile:
            return UIImage(systemName: "person.crop.circle")
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .movies:
            return UIImage(systemName: "popcorn.fill")
        case .favorite:
            return UIImage(systemName: "heart.fill")
        case .profile:
            return UIImage(systemName: "person.crop.circle.fill")
        }
    }
    
    var tabBarItem: UITabBarItem {
        UITabBarItem(title: self.title, image: self.image, selectedImage: self.selectedImage)
    }
}
