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

  var nextPage: Page? {
    switch self {
    case .idle: return PokemonListState.firstPage
    case .data(let data):
      return data.page.offset + data.page.limit < data.count ? data.page.next() : nil
    }
  }

  var hasNext: Bool { nextPage != nil }

  var items: [PokemonListItemViewModel] {
    switch self {
    case .idle: return []
    case .data(let data): return data.items
    }
  }

  var viewState: PokemonListViewState {
    switch self {
    case .idle:
      return .empty
    case .data(let data):
      let list = PokemonListViewState.List(items: data.items,
                                           hasNext: hasNext)
      return .list(list)
    }
  }

  static var firstPage: Page { Page(limit: 10) }
}
