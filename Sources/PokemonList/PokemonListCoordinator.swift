//
//  PokemonListCoordinator.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit
import os.log

final class PokemonListCoordinator {

  init(rootViewController: UISplitViewController) {
    self.splitViewController = rootViewController
  }

  private let splitViewController: UISplitViewController

  func start() {
    os_log("PokemonListCoordinator start", log: Log.general, type: .info)
    splitViewController.delegate = self
    splitViewController.preferredDisplayMode = .oneBesideSecondary
    let listViewModel = PokemonListViewModel(dependency: Dependency(), coordinator: self)
    let listViewController = PokemonListViewController(viewModel: listViewModel)
    let listNavigation = UINavigationController(rootViewController: listViewController)
    let emptyViewModel = EmptyPokemonDetailsViewModel(hint: .noItemSelected)
    let emptyViewController = EmptyPokemonDetailsViewController(viewModel: emptyViewModel)
    let emptyNavigation = UINavigationController(rootViewController: emptyViewController)
    emptyViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
    splitViewController.viewControllers = [listNavigation, emptyNavigation]
  }
}

extension PokemonListCoordinator: PokemonListViewModelCoordinating {
  func showDetails(for identifier: Identifier<Pokemon>) {
    let detailsViewModel = EmptyPokemonDetailsViewModel(hint: .noItemSelected)
    let detailsViewController = EmptyPokemonDetailsViewController(viewModel: detailsViewModel)
    detailsViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
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

private final class Dependency: PokemonAPIServiceProvider, ImageServiceProvider {
  lazy var networkService = NetworkServiceImp(transport: URLSession.shared,
                                              cache: URLCache.shared)
  var imageService: ImageService {
    ImageServiceImp(network: networkService)
  }

  var pokemonAPIService: PokemonAPIService {
    PokemonAPIServiceImp(requestBuilder: RequestBuilder(baseURL: "https://pokeapi.co/api/v2"),
                         network: networkService)
  }
}
