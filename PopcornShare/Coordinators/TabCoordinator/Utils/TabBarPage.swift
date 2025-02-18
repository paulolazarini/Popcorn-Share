//
//  TabBarPage.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 17/01/25.
//

import UIKit

enum TabBarPage: Int, CaseIterable {
    case movies = 0
    case search = 1
    case favorite = 2
    case profile = 3
    
    var title: String {
        switch self {
        case .movies:
            "Movies"
        case .favorite:
            "Favorites"
        case .profile:
            "Profile"
        case .search:
            "Search"
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
        case .search:
            return UIImage(systemName: "magnifyingglass")
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
        case .search:
            return UIImage(systemName: "magnifyingglass.fill")
        }
    }
    
    var tabBarItem: UITabBarItem {
        UITabBarItem(title: self.title, image: self.image, selectedImage: self.selectedImage)
    }
}
