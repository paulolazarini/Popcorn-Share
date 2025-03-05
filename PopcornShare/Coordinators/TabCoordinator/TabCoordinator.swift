//
//  TabCoordinator.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 23/05/24.
//

import UIKit
import SwiftUI
import Combine

import PopcornShareHome
import PopcornShareSearch
import PopcornShareProfile
import PopcornShareUtilities
import PopcornShareNetwork

protocol TabCoordinatorDelegate: AnyObject {
    func didSignOut()
}

@MainActor
public final class TabCoordinator: NSObject, @preconcurrency Coordinator {
    weak var delegate: TabCoordinatorDelegate?
    var childCoordinators: [Coordinator] = []

    let navigationController: UINavigationController
    let type: CoordinatorType = .tab
    
    let tabBarController: UITabBarController
    var homeCoordinator: HomeCoordinator?
    var searchCoordinator: SearchCoordinator?
    var profileCoordinator: ProfileCoordinator?
    
    private var cancelSet = Set<AnyCancellable>()
    private let networkManager: NetworkManagerType = NetworkManager()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        tabBarController.viewControllers = [
            makeHomeMovies(),
            makeSearchMovies(),
            makeProfile()
        ]
        
        tabBarController.tabBar.tintColor = UIColor(.primaryRed)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    private func makeSearchMovies() -> UINavigationController {
        searchCoordinator = SearchCoordinator(tabBarItem: TabBarPage.search.tabBarItem)
        searchCoordinator?.start()
        
        return searchCoordinator?.navigationController ?? UINavigationController()
    }
    
    private func makeHomeMovies() -> UINavigationController {
        homeCoordinator = HomeCoordinator(tabBarItem: TabBarPage.movies.tabBarItem)
        homeCoordinator?.start()
        
        return homeCoordinator?.navigationController ?? UINavigationController()
    }
    
    func makeProfile() -> UINavigationController {
        profileCoordinator = ProfileCoordinator(
            tabBarItem: TabBarPage.profile.tabBarItem,
            userManager: UserManager.shared,
            userUuid: try! AuthenticationManager.shared.getAuthenticatedUser().uid
        )
        profileCoordinator?.start()
        
        return profileCoordinator?.navigationController ?? UINavigationController()
    }
}
