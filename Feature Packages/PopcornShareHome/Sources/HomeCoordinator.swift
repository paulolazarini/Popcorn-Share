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

enum HomeNavigationEvents {
    case pop, dismiss
    case details(movie: MovieViewData)
    case seeMore(_ category: MovieCategory)
}

public final class HomeCoordinator: Coordinator {
    public weak var detailsDelegate: MovieDetailsDelegate?
    public var navigationController: UINavigationController
    
    private let userUuid: String
    private let moviesManager: MoviesManagerType
    
    private let navigationEvents = PassthroughSubject<HomeNavigationEvents, Never>()
    private var cancelSet = Set<AnyCancellable>()
    
    public init(
        navigationController: UINavigationController = UINavigationController(),
        moviesManager: MoviesManagerType,
        userUuid: String
    ) {
        self.navigationController = navigationController
        self.moviesManager = moviesManager
        self.userUuid = userUuid
        
        self.setupNavigationBindings()
    }
        
    public func start() {
        let viewModel = HomeViewModel(
            moviesManager: moviesManager,
            userUuid: userUuid,
            navigationEvents: navigationEvents
        )
        let view = HomeView(viewModel: viewModel)
        
        push(view)
    }
    
    private func presentSeeMore(for category: MovieCategory) {
        let viewModel = SeeMoreCategoryViewModel(
            type: category,
            navigationEvents: navigationEvents
        )
        let view = SeeMoreCategoryView(viewModel: viewModel)
        
        push(view)
    }
}

// MARK: - Navigation Events

private extension HomeCoordinator {
    func setupNavigationBindings() {
        navigationEvents
            .sink { [weak self] event in
                switch event {
                case .details(let movie):
                    self?.detailsDelegate?.presentMovieDetails(for: movie)
                case .seeMore(let category):
                    self?.presentSeeMore(for: category)
                case .pop:
                    self?.popVC()
                case .dismiss:
                    self?.dismiss()
                }
                
            }.store(in: &cancelSet)
    }
}
