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
public protocol ProfileCoordinatorDelegate: NSObject {
    func didSignOut()
}

@MainActor
public final class ProfileCoordinator: Coordinator {
    public weak var delegate: ProfileCoordinatorDelegate?
    public var navigationController: UINavigationController
    
    private let tabBarItem: UITabBarItem
    private let userUuid: String
    private let userManager: UserManagerType
    private let authManager: AuthenticationManagerType
    
    private var cancelSet = Set<AnyCancellable>()
    
    public init(
        tabBarItem: UITabBarItem,
        userManager: UserManagerType,
        authManager: AuthenticationManagerType,
        userUuid: String
    ) {
        self.tabBarItem = tabBarItem
        self.userUuid = userUuid
        self.userManager = userManager
        self.authManager = authManager
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
        
        viewModel.events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] events in
                guard let self else { return }
                
                switch events {
                case .onSignOutTapped:
                    self.signOut()
                }
            }.store(in: &cancelSet)

        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func signOut() {
        do {
            try self.authManager.signOut()
            self.delegate?.didSignOut()
        } catch {
            print(error.localizedDescription)
        }
    }
}
