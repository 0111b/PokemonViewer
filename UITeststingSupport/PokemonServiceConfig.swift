//
//  PokemonServiceConfig.swift
//  UITeststingSupport
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import Foundation

public struct PokemonServiceConfig: EnvironmentConvertible {

  public let listConfig: ListConfig
  public let detailsConfig: DetailsConfig

  public static let `default`: PokemonServiceConfig = PokemonServiceConfig(listConfig: .default,
                                                                           detailsConfig: .default)

  public enum ListConfig: String, EnvironmentConvertible, Defaultable {
    case error
    case sampleValue

    public static let `default`: ListConfig = .sampleValue
  }

  public enum DetailsConfig: String, EnvironmentConvertible, Defaultable {
    case error
    case sampleValue

    public static let `default`: DetailsConfig = .sampleValue
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
