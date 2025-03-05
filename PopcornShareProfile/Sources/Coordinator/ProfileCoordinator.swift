//
//  ProfileCoordinator.swift
//  PopcornShareSearch
//
//  Created by Paulo Lazarini on 04/03/25.
//

import UIKit
import SwiftUI
import Combine
import PopcornShareUtilities

@MainActor
public final class ProfileCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators = [Coordinator]()
    public var type: CoordinatorType = .profile
    
    let tabBarItem: UITabBarItem
    let userUuid: String
    let userManager: UserManagerType
    
    private var cancelSet = Set<AnyCancellable>()
    
    public init(
        tabBarItem: UITabBarItem,
        userManager: UserManagerType,
        userUuid: String
    ) {
        self.tabBarItem = tabBarItem
        self.userUuid = userUuid
        self.userManager = userManager
        self.navigationController = UINavigationController()
    }
    
    public func start() {
        let viewModel = ProfileViewModel(
            userManager: userManager,
            userUuid: userUuid
        )
        let view = ProfileView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        viewController.tabBarItem = tabBarItem
        
//        viewModel.events
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] events in
//                switch events {
//                case .onSignOutTapped:
//                    self?.delegate?.didSignOut()
//                }
//            }.store(in: &cancelSet)

        navigationController.pushViewController(viewController, animated: false)
    }
}
