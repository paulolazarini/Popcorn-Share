//
//  TabCoordinator.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 23/05/24.
//

import UIKit
import SwiftUI

public final class TabCoordinator: NSObject, Coordinator {

    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var tabBarController: UITabBarController
    
    var type: CoordinatorType = .tab
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        tabBarController.viewControllers = TabBarPage.allCases.map { makeViewController(for: $0) }
        tabBarController.tabBar.backgroundColor = UIColor(.customBackground)
        tabBarController.tabBar.tintColor = UIColor(.primaryRed)
        navigationController.setViewControllers([tabBarController], animated: false)
    }
}

extension TabCoordinator {
    private func makeViewController(for tabBarPage: TabBarPage) -> UIViewController {
        switch tabBarPage {
        case .movies:
            let viewModel = LoginViewModel()
            let view = LoginView(viewModel: viewModel)
            let viewController = UIHostingController(rootView: view)
            viewController.tabBarItem = tabBarPage.tabBarItem
            return viewController
        case .favorite:
            let viewModel = LoginViewModel()
            let view = LoginView(viewModel: viewModel)
            let viewController = UIHostingController(rootView: view)
            viewController.tabBarItem = tabBarPage.tabBarItem
            return viewController
        }
    }
}

enum TabBarPage: Int, CaseIterable {
    case movies = 0
    case favorite = 1
    
    var title: String {
        switch self {
        case .movies:
            "Movies"
        case .favorite:
            "Favorites"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .movies:
            return UIImage(systemName: "popcorn")
        case .favorite:
            return UIImage(systemName: "heart")
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .movies:
            return UIImage(systemName: "popcorn.fill")
        case .favorite:
            return UIImage(systemName: "heart.fill")
        }
    }
    
    var tabBarItem: UITabBarItem {
        UITabBarItem(title: self.title, image: self.image, selectedImage: self.selectedImage)
    }
}

