//
//  PokemonListViewState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import Foundation

enum PokemonListViewState {
  case empty
  case list(List)

  struct List {
    let items: [PokemonListItemViewModel]
    let hasNext: Bool
  }

  var items: [PokemonListItemViewModel] {
    if case .list(let list) = self {
      return list.items
    }
    return []
  }
}
