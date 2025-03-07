//
//  HomeCoordinator.swift
//  PopcornShareHome
//
//  Created by Paulo Lazarini on 04/03/25.
//

import UIKit
import SwiftUI
import Combine
import PopcornShareUtilities

@MainActor
public final class HomeCoordinator: Coordinator {
    public weak var detailsDelegate: MovieDetailsDelegate?
    public var navigationController: UINavigationController
    
    let tabBarItem: UITabBarItem
    
    private let navigationEvents = PassthroughSubject<HomeNavigationEvents, Never>()
    
    private var cancelSet = Set<AnyCancellable>()
    
    public init(tabBarItem: UITabBarItem) {
        self.tabBarItem = tabBarItem
        self.navigationController = UINavigationController()
        
        navigationEvents
            .sink { [weak self] event in
                switch event {
                case .details(let movie):
                    self?.detailsDelegate?.presentMovieDetails(for: movie)
                case .seeMore(let category):
                    self?.presentSeeMore(for: category)
                }
                
            }.store(in: &cancelSet)
    }
    
    public func start() {
        let viewModel = HomeViewModel(navigationEvents: navigationEvents)
        let view = HomeView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.tabBarItem = tabBarItem

        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func presentSeeMore(for category: MovieCategory) {
        let view = makeMovieCategoryExpandedGrid(category)
        
        push(view)
    }
    
    @ViewBuilder
    private func makeMovieCategoryExpandedGrid(_ category: MovieCategory) -> some View {
        switch category {
        case .popular:
            MoviesCategoryView(viewModel: PopularMoviesViewModel(), navigationEvents: navigationEvents)
        case .topRated:
            MoviesCategoryView(viewModel: TopRatedMoviesViewModel(), navigationEvents: navigationEvents)
        case .nowPlaying:
            MoviesCategoryView(viewModel: NowPlayingMoviesViewModel(), navigationEvents: navigationEvents)
        case .upcoming:
            MoviesCategoryView(viewModel: UpcomingMoviesViewModel(), navigationEvents: navigationEvents)
        }
    }
}

enum HomeNavigationEvents {
    case details(movie: MovieViewData)
    case seeMore(_ category: MovieCategory)
}
