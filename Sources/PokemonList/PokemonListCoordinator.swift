//
//  PokemonListCoordinator.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit
import os.log

final class PokemonListCoordinator {
  typealias Dependency = PokemonAPIServiceProvider & ImageServiceProvider

  init(dependency: Dependency, rootViewController: UISplitViewController) {
    self.dependency = dependency
    self.splitViewController = rootViewController
  }

  private let dependency: Dependency
  private let splitViewController: UISplitViewController

  func start() {
    os_log("PokemonListCoordinator start", log: Log.general, type: .info)
    splitViewController.delegate = self
    splitViewController.preferredDisplayMode = .oneBesideSecondary
    let listViewModel = PokemonListViewModel(dependency: dependency, coordinator: self)
    let listViewController = PokemonListViewController(viewModel: listViewModel)
    let listNavigation = UINavigationController(rootViewController: listViewController)
    let emptyViewModel = EmptyPokemonDetailsViewModel(hint: .noItemSelected)
    let emptyViewController = EmptyPokemonDetailsViewController(viewModel: emptyViewModel)
    let emptyNavigation = UINavigationController(rootViewController: emptyViewController)
    splitViewController.viewControllers = [listNavigation, emptyNavigation]
  }
}

extension PokemonListCoordinator: PokemonListViewModelCoordinating {
  func showDetails(for identifier: Identifier<Pokemon>) {
    let detailsViewModel = PokemonDetailsViewModel(dependency: dependency, identifier: identifier)
    let detailsViewController = PokemonDetailsViewController(viewModel: detailsViewModel)
    let detailsNavigation = UINavigationController(rootViewController: detailsViewController)
    splitViewController.showDetailViewController(detailsNavigation, sender: nil)
  }
}

extension PokemonListCoordinator: UISplitViewControllerDelegate {
  func splitViewController(_ splitViewController: UISplitViewController,
                           collapseSecondary secondaryViewController: UIViewController,
                           onto primaryViewController: UIViewController) -> Bool {
    if let navigationController = secondaryViewController as? UINavigationController,
       navigationController.visibleViewController is EmptyPokemonDetailsViewController {
      return true
    }
    return false
  }
}
