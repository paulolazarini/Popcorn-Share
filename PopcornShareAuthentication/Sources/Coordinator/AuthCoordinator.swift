//
//  AuthenticationCoordinator.swift
//  PopcornShareSearch
//
//  Created by Paulo Lazarini on 04/03/25.
//

import UIKit
import SwiftUI
import Combine
import PopcornShareUtilities

public protocol AuthCoordinatorDelegate: AnyObject {
    func didFinishAuthFlow()
}

public final class AuthCoordinator: Coordinator {
    public weak var delegate: AuthCoordinatorDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators = [Coordinator]()
    public var type: CoordinatorType = .auth
    
    let authManager: AuthenticationManagerType
    
    private var cancelSet = Set<AnyCancellable>()
    
    public init(
        navigationController: UINavigationController,
        authManager: AuthenticationManagerType
    ) {
        self.navigationController = navigationController
        self.authManager = authManager
    }
    
    public func start() {
        let viewModel = LoginViewModel(authManager: authManager)
        let view = LoginView(viewModel: viewModel)
        
        viewModel.events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] events in
                guard let self else { return }
                
                switch events {
                case .signUpTapped:
                    self.presentSignInFlow()
                case .didSignIn:
                    self.delegate?.didFinishAuthFlow()
                }
            }.store(in: &cancelSet)
        
        push(view, animated: true)
    }
    
    func presentSignInFlow() {
        let viewModel = SignUpViewModel(authManager: authManager) { [weak self] in
            self?.dismiss()
        }
        let view = SignUpView(viewModel: viewModel)
        
        present(view, presentationStyle: .overFullScreen)
    }
}
