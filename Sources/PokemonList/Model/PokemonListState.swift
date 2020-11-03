//
//  PokemonListState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import Foundation

struct PokemonListState {
  let layout: PokemonListLayout
  let list: List

  enum List {
    case idle
    case data(ListData)
  }

  struct ListData {
    let items: [PokemonListItemViewModel]
    let count: Int
    let page: Page
  }

  var nextPage: Page? {
    switch list {
    case .idle: return PokemonListState.firstPage
    case .data(let data):
      return data.page.offset + data.page.limit < data.count ? data.page.next() : nil
    }
  }

  var items: [PokemonListItemViewModel] {
    switch list {
    case .idle: return []
    case .data(let data): return data.items
    }
  }

  var viewState: PokemonListViewState {
    switch list {
    case .idle:
      return PokemonListViewState(items: [], loading: .clear, layout: layout)
    case .data(let data):
      let loading: LoadingViewState
      if nextPage != nil {
        loading = .loading
      } else {
        loading = .hint(Strings.Screens.PokemonList.noMoreItems)
      }
      return PokemonListViewState(items: data.items,
                                  loading: loading,
                                  layout: layout)
    }
  }

  static var firstPage: Page { Page(limit: 20) }
}
