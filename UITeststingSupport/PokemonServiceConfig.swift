//
//  PokemonServiceConfig.swift
//  UITeststingSupport
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import Foundation

public struct PokemonServiceConfig: EnvironmentConvertible {
  public init(listConfig: ListConfig = .default,
              detailsConfig: DetailsConfig = .default) {
    self.listConfig = listConfig
    self.detailsConfig = detailsConfig
  }

  public let listConfig: ListConfig
  public let detailsConfig: DetailsConfig

  public static let `default` = PokemonServiceConfig()

  public enum ListConfig: String, EnvironmentConvertible, Defaultable {
    case error
    case sampleValue

    public static let `default`: ListConfig = .error
  }

  public enum DetailsConfig: String, EnvironmentConvertible, Defaultable {
    case error
    case sampleValue

    public static let `default`: DetailsConfig = .error
  }

  static func decode(from env: Environment) -> PokemonServiceConfig {
    PokemonServiceConfig(listConfig: .decode(from: env),
                         detailsConfig: .decode(from: env))
  }

  func encode(to env: inout Environment) {
    listConfig.encode(to: &env)
    detailsConfig.encode(to: &env)
  }
}
