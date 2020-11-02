//
//  PokemonListCoordinator.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit
import os.log

final class PokemonListCoordinator {

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  private let navigationController: UINavigationController

  func start() {
    os_log("PokemonListCoordinator start", log: Log.general, type: .info)
    let viewModel = PokemonListViewModel(dependency: Dependency())
    let viewController = PokemonListViewController(viewModel: viewModel)
    navigationController.setViewControllers([viewController], animated: true)
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
