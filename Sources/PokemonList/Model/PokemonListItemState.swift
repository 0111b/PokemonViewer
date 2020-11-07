//
//  PokemonListItemState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import UIKit

struct PokemonListItemState {

  let id: Identifier<Pokemon>
  let types: [PokemonType]
  let image: UIImage?
  let loading: LoadingState

  enum LoadingState {
    case idle
    case detailsRequest(Disposable)
    case imageRequest(Disposable)
    case done
  }

  init(id: Identifier<Pokemon>) {
    self.id = id
    types = []
    loading = .idle
  }

  func with(detailsRequest: Disposable) -> PokemonListItemState {
    PokemonListItemState(id: id, types: types, loading: .detailsRequest(detailsRequest))
  }


  private init(id: Identifier<Pokemon>,
               types: [PokemonType],
               loading: PokemonListItemState.LoadingState) {
    self.id = id
    self.types = types
    self.loading = loading
  }

//  var name: String {
//    id.rawValue.capitalized
//  }


  case idle(id: Identifier<Pokemon>)
  case detailsRequest(id: Identifier<Pokemon>, details: Disposable)
  case imageRequest(id: Identifier<Pokemon>, types: [PokemonType], image: Disposable)
  case done(id: Identifier<Pokemon>, types: [PokemonType], image: UIImage?)

  func canStartRequest() -> Bool {
    switch self {
    case .idle: return true
    default: return false
    }
  }

  func canceled() -> PokemonListItemState {
    switch self {
    case .done: return self
    default: return .idle()
    }
  }
}
