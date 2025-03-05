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
    public var navigationController: UINavigationController
    public var childCoordinators = [Coordinator]()
    public var type: CoordinatorType = .search
    
    let tabBarItem: UITabBarItem
    
    private var cancelSet = Set<AnyCancellable>()
    
    public init(tabBarItem: UITabBarItem) {
        self.tabBarItem = tabBarItem
        self.navigationController = UINavigationController()
    }
    
    public func start() {
        let viewModel = SearchViewModel()
        let view = SearchView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.tabBarItem = tabBarItem

        navigationController.pushViewController(viewController, animated: false)
    }
}
