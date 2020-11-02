//
//  PokemonListItemState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import Foundation

enum PokemonListItemState {
  case idle
  case detailsRequest(Disposable)
  case imageRequest(Disposable)
  case done

  var canStartRequest: Bool {
    switch self {
    case .idle: return true
    default: return false
    }
  }

  func canceled() -> PokemonListItemState {
    switch self {
    case .done: return .done
    default: return .idle
    }
  }
}
