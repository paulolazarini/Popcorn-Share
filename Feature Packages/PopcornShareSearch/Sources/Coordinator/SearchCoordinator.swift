//
//  SearchCoordinator.swift
//  PopcornShareSearch
//
//  Created by Paulo Lazarini on 04/03/25.
//

import UIKit
import SwiftUI
import Combine
import PopcornShareUtilities

@MainActor
public final class SearchCoordinator: Coordinator {
    public weak var detailsDelegate: MovieDetailsDelegate?
    public var navigationController: UINavigationController
    
    let tabBarItem: UITabBarItem
    
    private var cancelSet = Set<AnyCancellable>()
    
    public init(tabBarItem: UITabBarItem) {
        self.tabBarItem = tabBarItem
        self.navigationController = UINavigationController()
    }
    
    public func start() {
        let viewModel = SearchViewModel()
        let view = SearchView(viewModel: viewModel)

        viewModel.navigationEvents
            .sink { [weak self] event in
                switch event {
                case .details(let movie):
                    self?.detailsDelegate?.presentMovieDetails(for: movie)
                }
                
            }.store(in: &cancelSet)
        
        push(view, tabBarItem: tabBarItem)
    }
}

enum SearchNavigationEvents {
    case details(movie: MovieViewData)
}
