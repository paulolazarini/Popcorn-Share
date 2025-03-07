//
//  AppCoordinator.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 23/05/24.
//

import UIKit
import SwiftUI
import PopcornShareUtilities
import PopcornShareAuthentication

final class AppCoordinator: Coordinator {
    public var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var authCoordinator: AuthCoordinator?
    var tabCoordinator: TabCoordinator?
    
    @MainActor
    func start() {
        let user = try? AuthenticationManager.shared.currentUser()
        if user != nil {
            presentTabCoordinator()
        } else {
            presentAuthCoordinator()
        }
    }
    
    @MainActor
    private func presentAuthCoordinator() {
        navigationController.viewControllers.removeAll()
        authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            authManager: AuthenticationManager.shared
        )
        authCoordinator?.delegate = self
        guard let authCoordinator else { return }
        authCoordinator.start()
    }
    
    @MainActor
    private func presentTabCoordinator() {
        navigationController.viewControllers.removeAll()
        tabCoordinator = TabCoordinator(navigationController: navigationController)
        tabCoordinator?.delegate = self
        guard let tabCoordinator else { return }
        tabCoordinator.start()
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
