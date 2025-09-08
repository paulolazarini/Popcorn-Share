//
//  TabCoordinator.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 23/05/24.
//

import UIKit
import SwiftUI
import Combine

//import PopcornShareHome
//import PopcornShareSearch
import PopcornShareProfile

import PopcornShareNetwork
import PopcornShareUtilities

protocol TabCoordinatorDelegate: AnyObject {
    func didSignOut()
}

enum NavigationEvents {
    case movieList(MovieCategory)
    case movieDetails(MovieViewData)
    case addWatchlist(MovieViewData)
    case createWatchlist
}

public final class TabCoordinator: NSObject, Coordinator {
    public var navigationController: UINavigationController
    weak var delegate: TabCoordinatorDelegate?
    
    let tabBarController: UITabBarController
    
    var profileCoordinator: ProfileCoordinator?
    
    private var cancelSet = Set<AnyCancellable>()
    private let networkManager: NetworkManagerType = NetworkManager()
    private let navigationEvents = PassthroughSubject<NavigationEvents, Never>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        super.init()
        
        self.setupBinding()
    }
    
    private func setupBinding() {
        navigationEvents
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case let .addWatchlist(movie):
                    presentAddToWatchlist(movie)
                case let .movieDetails(movie):
                    presentMovieDetails(for: movie)
                case .createWatchlist:
                    break
                case let .movieList(category):
                    presentMovieList(for: category)
                }
            }.store(in: &cancelSet)
    }
    
    public func start() {
        tabBarController.viewControllers = [
            makeHomeMovies(),
            makeProfile()
        ]
        
        tabBarController.tabBar.tintColor = UIColor(.primaryRed)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    private func makeHomeMovies() -> UIViewController {
        let viewModel = HomeViewModel(
            navigationEvents: navigationEvents,
            userUuid: try! AuthenticationManager.shared.currentUser().uid
        )
        let view = HomeView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.tabBarItem = TabBarPage.movies.tabBarItem
           
        return viewController
    }
    
    func makeProfile() -> UINavigationController {
        profileCoordinator = ProfileCoordinator(
            userManager: UserManager.shared,
            authManager: AuthenticationManager.shared,
            userUuid: try! AuthenticationManager.shared.currentUser().uid
        )
        profileCoordinator?.navigationController.tabBarItem = TabBarPage.profile.tabBarItem
        profileCoordinator?.delegate = self
        profileCoordinator?.start()
        
        return profileCoordinator?.navigationController ?? UINavigationController()
    }
    
    private func presentAddToWatchlist(_ movie: MovieViewData) {
        let view = AddToWatchlistView(movie: movie)
        let viewController = UIHostingController(rootView: view)
        
        navigationController.topMostViewController.present(viewController, animated: true)
    }
    
    private func presentMovieDetails(for movie: MovieViewData) {
        let viewModel = DetailsMovieViewModel(
            navigationEvents: navigationEvents,
            movieId: movie.id
        )
        let view = DetailsMovieView(viewModel: viewModel, onDismiss: dismiss)
        let viewController = UIHostingController(rootView: view)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        self.navigationController.present(navigationController, animated: true)
    }
    
    private func presentMovieList(for category: MovieCategory) {
        let viewModel = MovieListViewModel(
            type: category,
            navigationEvents: navigationEvents
        )
        let view = MovieListView(viewModel: viewModel)
        
        push(view)
    }
}

extension TabCoordinator: ProfileCoordinatorDelegate {
    public func didSignOut() {
        delegate?.didSignOut()
    }
}
