//
//  PokemonListState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import Foundation

struct PokemonListState: Equatable {
  let layout: PokemonListLayout
  let list: ListData?
  let pageRequest: RequestState

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
    switch pageRequest {
    case .pending:
      loading = .loading
    case .error(let error):
      loading = .hint(error.localizedDescription)
    case .idle:
      loading = nextPage == nil ? .hint(Strings.Screens.PokemonList.noMoreItems) : .clear
    }
    return PokemonListViewState(items: items,
                                loading: loading,
                                layout: layout)
  }

  func with(layout updatedLayout: PokemonListLayout) -> PokemonListState {
    PokemonListState(layout: updatedLayout, list: list, pageRequest: pageRequest)
  }

  func with(error: NetworkError) -> PokemonListState {
    PokemonListState(layout: layout, list: list, pageRequest: .error(error))
  }

  func with(pageRequest request: Disposable) -> PokemonListState {
    PokemonListState(layout: layout, list: list, pageRequest: .pending(request))
  }

  func with(list data: ListData) -> PokemonListState {
    PokemonListState(layout: layout, list: data, pageRequest: .idle)
  }

  func canStartRequest() -> Bool {
    switch pageRequest {
    case .pending: return false
    default: return true
    }
  }

  static let empty = PokemonListState(layout: .list, list: nil, pageRequest: .idle)

  static var firstPage: Page { Page(limit: 5) }
}
