//
//  PokemonListViewState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import Foundation

struct PokemonListViewState {
  let items: [PokemonListItemViewModel]
  let loading: LoadingViewState
  let layout: PokemonListLayout

  static let empty = PokemonListViewState(items: [], loading: .clear, layout: .list)
}
