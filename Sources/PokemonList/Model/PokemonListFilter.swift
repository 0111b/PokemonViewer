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
}

extension PokemonListFilter {
  init() {
    name = String()
  }
}
