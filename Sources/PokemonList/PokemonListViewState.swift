//
//  PokemonListViewState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import Foundation

enum PokemonListViewState {
  case idle

  var currentPage: PokemonAPI.Page? {
    switch self {
    case .idle: return nil
    }
  }
}
