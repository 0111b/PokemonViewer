//
//  PokemonDetailsState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import Foundation

enum PokemonDetailsState {
  case idle
  case loading(Disposable)
  case error(NetworkError)
  case done(PokemonDetails)

  var viewState: PokemonDetailsViewState {
    switch self {
    case .idle:
      return .idle
    case .loading:
      return .loading
    case .error(let error):
      return .error(error.recoveryOptions)
    case .done(let pokemon):
      return .data(pokemon)
    }
  }
}

private extension NetworkError {
  var recoveryOptions: String {
    switch self {
    case .transportError:
      return Strings.Screens.PokemonDetails.Error.transport
    default:
      return Strings.Screens.PokemonDetails.Error.default
    }
  }
}
