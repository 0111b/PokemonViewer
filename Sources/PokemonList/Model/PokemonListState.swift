//
//  PokemonListState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import Foundation

struct PokemonListState: Equatable {
  let layout: PokemonListLayout
  let filter: PokemonListFilter
  let list: ListData?
  let pageRequest: PageRequestState

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
    let items: [PokemonListItemViewModel] = self.items.compactMap { $0.applying(filter: filter) }
    let loading: PageLoadingViewState = {
      switch pageRequest {
      case .pending:
        return .loading
      case .error(let error):
        return .hint(error.recoveryOptions)
      case .idle:
        guard nextPage == nil else { return .clear }
        if filter.hasConditions {
          return items.isEmpty ? .hint(Strings.Screens.PokemonList.Search.noMatch) : .clear
        } else {
          return .hint(Strings.Screens.PokemonList.noMoreItems)
        }
      }
    }()
    return PokemonListViewState(items: items,
                                loading: loading,
                                layout: layout)
  }

  func with(layout updatedLayout: PokemonListLayout) -> PokemonListState {
    PokemonListState(layout: updatedLayout, filter: filter, list: list, pageRequest: pageRequest)
  }

  func with(error: NetworkError) -> PokemonListState {
    PokemonListState(layout: layout, filter: filter, list: list, pageRequest: .error(error))
  }

  func with(pageRequest request: Disposable) -> PokemonListState {
    PokemonListState(layout: layout, filter: filter, list: list, pageRequest: .pending(request))
  }

  func with(list data: ListData) -> PokemonListState {
    PokemonListState(layout: layout, filter: filter, list: data, pageRequest: .idle)
  }

  func with(nameFilter name: String) -> PokemonListState {
    PokemonListState(layout: layout, filter: PokemonListFilter(name: name), list: list, pageRequest: pageRequest)
  }

  func canStartRequest(forced: Bool) -> Bool {
    switch pageRequest {
    case .idle: return true
    case .error where forced: return true
    default: return false
    }
  }

  static let empty = PokemonListState(layout: .list, filter: PokemonListFilter(), list: nil, pageRequest: .idle)

  static var firstPage: Page { Page(limit: 100) }
}

private extension NetworkError {
  var recoveryOptions: String {
    switch self {
    case .transportError:
      return Strings.Screens.PokemonList.Error.transport
    default:
      return Strings.Screens.PokemonList.Error.default
    }
  }
}
