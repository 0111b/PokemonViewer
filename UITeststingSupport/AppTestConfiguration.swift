//
//  AppTestConfiguration.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import Foundation

public final class AppTestConfiguration {

  public init(raw env: [String: String]) {
    self.imageService = .decode(from: env)
    self.pokemonService = .decode(from: env)
  }

  public func toRawValue() -> [String: String] {
    var env = [String: String]()
    imageService.encode(to: &env)
    pokemonService.detailsConfig.encode(to: &env)
    pokemonService.listConfig.encode(to: &env)
    return env
  }

  public init(pokemonService: PokemonServiceConfig = .default, imageService: ImageServiceConfig = .default) {
    self.pokemonService = pokemonService
    self.imageService = imageService
  }

  public let imageService: ImageServiceConfig
  public let pokemonService: PokemonServiceConfig

  public static let testingFlag = "--enable-testing"
}
