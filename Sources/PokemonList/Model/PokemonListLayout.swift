//
//  PokemonListLayout.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import Foundation

enum PokemonListLayout {
  case list
  case grid

  func toggle() -> PokemonListLayout {
    switch self {
    case .grid: return .list
    case .list: return .grid
    }
  }
}
