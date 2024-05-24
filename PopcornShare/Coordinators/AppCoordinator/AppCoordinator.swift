//
//  AppCoordinator.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 23/05/24.
//

import UIKit

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
    
    func start() {
        let tabCoordinator = TabCoordinator(navigationController: navigationController)
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

// MARK: - METHODS
extension Coordinator {
    private func push(_ vc: UIViewController, _ animated: Bool = false) {
        self.navigationController.pushViewController(vc, animated: animated)
    }
    
    private func popVC(_ animated: Bool = false) {
        self.navigationController.popViewController(animated: animated)
    }
    
    private func dismiss(_ animated: Bool = false) {
        self.navigationController.dismiss(animated: animated)
    }
    
    private func present(_ vc: UIViewController, _ animated: Bool = false) {
        self.navigationController.present(vc, animated: animated)
    }
}
