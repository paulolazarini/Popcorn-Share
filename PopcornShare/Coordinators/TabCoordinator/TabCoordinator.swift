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
import PopcornShareNetwork
import PopcornShareUtilities

protocol TabCoordinatorDelegate: AnyObject {
    func didSignOut()
}

public final class TabCoordinator: NSObject, Coordinator {

    weak var delegate: TabCoordinatorDelegate?

    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var tabBarController: UITabBarController
    
    var type: CoordinatorType = .tab
    
    var cancelSet = Set<AnyCancellable>()
    
    let networkManager: NetworkManagerType = NetworkManager()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        tabBarController.viewControllers = [
            makePopularMovies(),
            makeSearchMovies(),
            makeFavoriteMovies(),
            makeProfile()
        ]
        tabBarController.tabBar.tintColor = UIColor(.primaryRed)

        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    private func makeSearchMovies() -> UINavigationController {
        let view = SearchView(viewModel: SearchViewModel())
        let viewController = UIHostingController(rootView: view)
        viewController.tabBarItem = TabBarPage.search.tabBarItem

        let navController = UINavigationController(rootViewController: viewController)
        navController.setNavigationBarHidden(true, animated: false)
        return navController
    }
    
    private func makePopularMovies() -> UINavigationController {
        let view = HomeView()
        let viewController = UIHostingController(rootView: view)
        viewController.tabBarItem = TabBarPage.movies.tabBarItem

        let navController = UINavigationController(rootViewController: viewController)
        navController.setNavigationBarHidden(true, animated: false)
        return navController
    }
    
    func makeFavoriteMovies() -> UIViewController {
        let viewModel = FavoriteMoviesViewModel(serviceManager: networkManager)
        let view = FavoriteMoviesView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.tabBarItem = TabBarPage.favorite.tabBarItem
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.setNavigationBarHidden(true, animated: false)
        return navController
    }
    
    func makeProfile() -> UIViewController {
        let viewModel = ProfileViewModel()
        let view = ProfileView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.tabBarItem = TabBarPage.profile.tabBarItem
        
        viewModel.events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] events in
                switch events {
                case .onSignOutTapped:
                    self?.delegate?.didSignOut()
                }
            }.store(in: &cancelSet)
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.setNavigationBarHidden(true, animated: false)
        return navController
    }
}
