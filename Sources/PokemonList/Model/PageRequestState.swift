//
//  PageRequestState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import Foundation

enum PageRequestState {
  case idle
  case pending(Disposable)
  case error(NetworkError)
}

extension PageRequestState: Equatable {

  static func == (lhs: PageRequestState, rhs: PageRequestState) -> Bool {
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
