//
//  AppCoordinator.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 23/05/24.
//

import UIKit
import SwiftUI
import FirebaseCore
import FirebaseAuth

protocol AppCoordinatorProtocol: Coordinator {
    func start()
}

class AppCoordinator: AppCoordinatorProtocol {
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()

    var type: CoordinatorType = .app

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var authCoordinator: AuthCoordinator?
    var tabCoordinator: TabCoordinator?
    
    func start() {
        let user = try? AuthenticationManager.shared.getAuthenticatedUser()
        if let user {
            presentTabCoordinator()
        } else {
            presentAuthCoordinator()
        }
    }
    
    private func presentAuthCoordinator() {
        navigationController.viewControllers.removeAll()
        authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator?.delegate = self
        guard let authCoordinator else { return }
        authCoordinator.start()
        childCoordinators.append(authCoordinator)
    }
    
    private func presentTabCoordinator() {
        navigationController.viewControllers.removeAll()
        tabCoordinator = TabCoordinator(navigationController: navigationController)
        tabCoordinator?.delegate = self
        guard let tabCoordinator else { return }
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func didFinishAuthFlow() {
        navigationController.viewControllers.removeAll()
        start()
    }
}

extension AppCoordinator: TabCoordinatorDelegate {
    func didSignOut() {
        navigationController.viewControllers.removeAll()
        start()
    }
}
