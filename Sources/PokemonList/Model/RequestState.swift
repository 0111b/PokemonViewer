//
//  RequestState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import Foundation

enum RequestState {
  case idle
  case pending(Disposable)
  case error(NetworkError)
}

extension RequestState: Equatable {

  static func == (lhs: RequestState, rhs: RequestState) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle),
         (.pending, .pending),
         (.error, .error):
      return true
    default:
      return false
    }
  }

}
