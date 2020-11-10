//
//  AccessibilityId.swift
//  UITeststingSupport
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import Foundation

public enum AccessibilityId {
  public enum PokemonList {
    public static let screen = "PokemonListScreen"
    public static let gridLayoutButton = "gridLayoutButton"
    public static let listLayoutButton = "listLayoutButton"
    public static let pokemonList = "pokemonList"
    public static let statusView = "statusView"
    public static let statusHint = "statusHint"
    public static let statusActivity = "statusActivity"
    public static let pokemonFilter = "pokemonFilter"
    public static func pokemon(at index: Int) -> String { "Pokemon-\(index)" }
  }

  public enum PokemonDetails {
    public static let screen = "PokemonDetails"
    public static let errorView = "errorView"
    public static let contentView = "contentView"
    public static let pokemonName = "pokemonName"
    public static let spriteLegendButton = "spriteLegendButton"
  }

  public enum SpriteLegend {
    public static let screen = "SpriteLegend"
  }
}
