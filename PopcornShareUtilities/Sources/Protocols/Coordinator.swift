//
//  Coordinator.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 23/05/24.
//

import UIKit
import SwiftUI

@MainActor
public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorType { get set }
}

public extension Coordinator {
    var childCoordinators: [Coordinator] { [] }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
    
    func present(
        _ view: some View,
        animated: Bool = true,
        presentationStyle: UIModalPresentationStyle = .pageSheet
    ) {
        let viewController = UIHostingController(rootView: view)
        viewController.modalPresentationStyle = presentationStyle
        
        navigationController.present(viewController, animated: animated)
    }
    
    func push(
        _ view: some View,
        animated: Bool = true
    ) {
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: animated)
    }
}

public enum CoordinatorType {
    case app, auth, tab, tabItem, profile
}
