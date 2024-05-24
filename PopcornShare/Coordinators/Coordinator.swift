//
//  Coordinator.swift
//  PopcornShare
//
//  Created by Paulo Lazarini on 23/05/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorType { get set }
}

enum CoordinatorType {
    case app, tab, tabItem
}
