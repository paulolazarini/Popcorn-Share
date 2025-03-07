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

import PopcornShareNetwork
import PopcornShareUtilities

protocol TabCoordinatorDelegate: AnyObject {
    func didSignOut()
}

@MainActor
public final class TabCoordinator: NSObject, Coordinator {
    public var navigationController: UINavigationController
    weak var delegate: TabCoordinatorDelegate?
    
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
        searchCoordinator?.detailsDelegate = self
        searchCoordinator?.start()
        
        return searchCoordinator?.navigationController ?? UINavigationController()
    }
    
    private func makeHomeMovies() -> UINavigationController {
        homeCoordinator = HomeCoordinator(tabBarItem: TabBarPage.movies.tabBarItem)
        homeCoordinator?.detailsDelegate = self
        homeCoordinator?.start()
        
        return homeCoordinator?.navigationController ?? UINavigationController()
    }
    
    func makeProfile() -> UINavigationController {
        profileCoordinator = ProfileCoordinator(
            tabBarItem: TabBarPage.profile.tabBarItem,
            userManager: UserManager.shared,
            authManager: AuthenticationManager.shared,
            userUuid: try! AuthenticationManager.shared.currentUser().uid
        )
        profileCoordinator?.delegate = self
        profileCoordinator?.start()
        
        return profileCoordinator?.navigationController ?? UINavigationController()
    }
}

extension TabCoordinator: ProfileCoordinatorDelegate {
    public func didSignOut() {
        delegate?.didSignOut()
    }
}

extension TabCoordinator: MovieDetailsDelegate {
    public func presentMovieDetails(for movie: MovieViewData) {
        let view = DetailsMovieView(viewModel: DetailsMovieViewModel(movieId: movie.id), onDismiss: dismiss)
        let viewController = UIHostingController(rootView: view)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        self.navigationController.present(navigationController, animated: true)
    }
}
