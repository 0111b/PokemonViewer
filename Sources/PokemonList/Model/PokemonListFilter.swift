//
//  PokemonListFilter.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 06.11.2020.
//

import Foundation

struct PokemonListFilter: Equatable {
  let name: String

  var hasConditions: Bool {
    !name.isEmpty
  }

  func matching(_ item: PokemonListItemViewModel) -> Bool {
    guard !name.isEmpty else { return true }
    return item.identifier.rawValue.range(of: name, options: .caseInsensitive) != nil
  }
}

extension PokemonListFilter {
  init() {
    name = String()
  }
}
