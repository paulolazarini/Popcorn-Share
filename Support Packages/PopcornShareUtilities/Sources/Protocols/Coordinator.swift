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
    func start()
}

public extension Coordinator {
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
    
    func popVC() {
        navigationController.popViewController(animated: true)
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
