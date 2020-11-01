//
//  PokemonListState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import Foundation

enum PokemonListState {
  case idle
  case data(ListData)

  struct ListData {
    let items: [PokemonListItemViewModel]
    let count: Int
    let page: Page
  }

  var viewState: PokemonListViewState {
    switch self {
    case .idle:
      return .empty
    case .data(let data):
      let list = PokemonListViewState.List(items: data.items,
                                           hasNext: data.page.offset < data.count)
      return .list(list)
    }
  }
}
