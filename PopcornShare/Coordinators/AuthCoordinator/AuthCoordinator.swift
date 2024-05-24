//
//  AuthCoordinator.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 24/05/24.
//

import UIKit
import SwiftUI
import Combine

import FirebaseCore
import FirebaseAuth

protocol AuthCoordinatorDelegate: AnyObject {
    func didFinishAuthFlow()
}

protocol AuthCoordinatorProtocol: Coordinator {
    func start()
}

class AuthCoordinator: AuthCoordinatorProtocol {
    
    weak var delegate: AuthCoordinatorDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()

    var type: CoordinatorType = .auth

    var cancelSet = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = LoginViewModel()
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
        let viewModel = SignUpViewModel() { [weak self] in
            self?.dismiss()
        }
        let view = SignUpView(viewModel: viewModel)
        
        present(view, presentationStyle: .overFullScreen)
    }
}
