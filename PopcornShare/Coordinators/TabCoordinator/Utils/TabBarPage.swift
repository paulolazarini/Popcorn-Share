//
//  TabBarPage.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 17/01/25.
//

import UIKit

enum TabBarPage: Int, CaseIterable {
    case movies = 0
    case profile = 1
    
    var title: String {
        switch self {
        case .movies:
            "Movies"
        case .profile:
            "Profile"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .movies:
            return UIImage(systemName: "popcorn")
        case .profile:
            return UIImage(systemName: "person.crop.circle")
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .movies:
            return UIImage(systemName: "popcorn.fill")
        case .profile:
            return UIImage(systemName: "person.crop.circle.fill")
        }
    }
    
    var tabBarItem: UITabBarItem {
        UITabBarItem(title: self.title, image: self.image, selectedImage: self.selectedImage)
    }
}
