//
//  PokemonDetailsViewState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import Foundation

enum PokemonDetailsViewState {
  case idle
  case error(String)
  case loading
  case data(Pokemon)

  var isLoading: Bool {
    switch self {
    case .loading: return true
    default: return false
    }
  }

  var error: String? {
    switch self {
    case .error(let error): return error
    default: return nil
    }
  }

  var pokemon: Pokemon? {
    switch self {
    case .data(let pokemon): return pokemon
    default: return nil
    }
  }
}
