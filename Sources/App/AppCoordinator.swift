//
//  AppCoordinator.swift
//  PockemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit

final class AppCoordinator {
  private let window: UIWindow
  private lazy var navigationController = UINavigationController()

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    window.rootViewController = navigationController
    let rootController = UIViewController()
    rootController.view.backgroundColor = .systemBlue
    navigationController.setViewControllers([rootController], animated: false)
  }
}
