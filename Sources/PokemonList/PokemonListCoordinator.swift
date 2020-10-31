//
//  PokemonListCoordinator.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit

final class PokemonListCoordinator {

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  private let navigationController: UINavigationController

  func start() {
    let viewModel = PokemonListViewModel()
    let viewController = PokemonListViewController(viewModel: viewModel)
    navigationController.setViewControllers([viewController], animated: true)
  }
}
