//
//  AppCoordinator.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit

final class AppCoordinator {

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    window.rootViewController = rootViewController
    pokemonList.start()
  }

  private let window: UIWindow

  private lazy var rootViewController = UINavigationController()

  private lazy var pokemonList: PokemonListCoordinator = {
    PokemonListCoordinator(navigationController: rootViewController)
  }()

}
