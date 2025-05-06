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

public final class SearchCoordinator: Coordinator {
    public weak var detailsDelegate: MovieDetailsDelegate?
    public var navigationController: UINavigationController
    
    private var cancelSet = Set<AnyCancellable>()
    
    public init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
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
        
        push(view)
    }
}

enum SearchNavigationEvents {
    case details(movie: MovieViewData)
}
