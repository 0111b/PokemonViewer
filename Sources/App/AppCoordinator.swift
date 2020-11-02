//
//  AppCoordinator.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit
import os.log

final class AppCoordinator {

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    if #available(iOS 12.0, *) {
      os_signpost(.event, log: Log.pointsOfInterest, name: #function)
    }
    os_log("AppCoordinator start", log: Log.general, type: .info)
    window.rootViewController = rootViewController
    pokemonList.start()
  }

  private let window: UIWindow

  private lazy var rootViewController = UINavigationController()

  private lazy var pokemonList: PokemonListCoordinator = {
    PokemonListCoordinator(navigationController: rootViewController)
  }()

}
