//
//  AppConfiguration.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import Foundation

public final class AppTestConfiguration {
  public init(raw: [String: String]) {
    self.pokemonService = .default
    self.imageService = .default
  }

  public func toRawValue() -> [String: String] {
    return [:]
  }

  public init(pokemonService: PokemonServiceConfig = .default, imageService: ImageServiceConfig = .default) {
    self.pokemonService = pokemonService
    self.imageService = imageService
  }

  public let imageService: ImageServiceConfig
  public let pokemonService: PokemonServiceConfig

  public static let testingFlag = "--enable-testing"
}

public enum ImageServiceConfig: String {
  case error
  case sampleValue

  public static let `default`: ImageServiceConfig = .sampleValue
}

public enum PokemonServiceConfig: String {
  case error
  case sampleValue

  public static let `default`: PokemonServiceConfig = .sampleValue
}
