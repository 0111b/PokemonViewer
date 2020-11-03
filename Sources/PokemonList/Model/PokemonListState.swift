//
//  PokemonListState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import Foundation

struct PokemonListState {
  let layout: PokemonListLayout
  let list: ListData?
  let pageRequest: Disposable?

  struct ListData: Equatable {
    let items: [PokemonListItemViewModel]
    let count: Int
    let page: Page
  }

  var nextPage: Page? {
    guard let data = list else { return PokemonListState.firstPage }
    return data.page.offset + data.page.limit < data.count ? data.page.next() : nil
  }

  var items: [PokemonListItemViewModel] {
    list?.items ?? []
  }

  var viewState: PokemonListViewState {
    let loading: LoadingViewState
    if pageRequest != nil {
      loading = .loading
    } else if nextPage == nil {
      loading = .hint(Strings.Screens.PokemonList.noMoreItems)
    } else {
      loading = .clear
    }
    return PokemonListViewState(items: items,
                                loading: loading,
                                layout: layout)
  }

  func with(layout updatedLayout: PokemonListLayout) -> PokemonListState {
    PokemonListState(layout: updatedLayout, list: list, pageRequest: pageRequest)
  }

  func hasVisualChanges(from other: PokemonListState) -> Bool {
    if layout != other.layout || list != other.list { return true }
    switch (pageRequest, other.pageRequest) {
    case (.some, .some), (nil, nil):
      return false
    default:
      return true
    }
  }

  static let empty = PokemonListState(layout: .list, list: nil, pageRequest: nil)

  static var firstPage: Page { Page(limit: 20) }
}
