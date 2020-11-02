//
//  PokemonListViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import Foundation
import os.log

final class PokemonListViewModel {
  typealias Dependency = PokemonAPIServiceProvider & ImageServiceProvider

  init(dependency: Dependency) {
    self.dependency = dependency
  }

  private let dependency: Dependency

  @Protected
  private var state = PokemonListState.idle {
    didSet {
      viewStateRelay.value = state.viewState
    }
  }

  @Protected
  private var pageRequest: Disposable?

  private func fetch(page: Page, cachePolicy: RequestCachePolicy) {
    guard pageRequest == nil else { return }
    pageRequest = dependency.pokemonAPIService.list(page: page, cachePolicy: .cacheFirst) { [weak self] result in
      guard let self = self else { return }
      defer { self.pageRequest = nil }
      switch result {
      case .failure(let error):
        os_log("PokemonListViewModel fetch error %@", log: Log.general, type: .error, String(describing: error))
      case .success(let pageData):
        let currentState = self.state
        let newItems = pageData.items.map { PokemonListItemViewModel(dependency: self.dependency, id: $0) }
        let items = page.isFirst ? newItems : currentState.items + newItems
        let listData = PokemonListState.ListData(items: items,
                                                 count: pageData.count,
                                                 page: page)
        self.state = .data(listData)
      }
    }
  }

  private func fetchNext() {
    guard let nextPage = state.nextPage else { return }
    fetch(page: nextPage, cachePolicy: .cacheFirst)
  }

  private func reload() {
    fetch(page: PokemonListState.firstPage, cachePolicy: .networkFirst)
  }

  // MARK: - Input -

  func viewDidLoad() {
    os_log("PokemonListViewModel viewDidLoad", log: Log.general, type: .info)
    fetchNext()
  }

  func askForNextPage() {
    os_log("PokemonListViewModel askForNextPage", log: Log.general, type: .info)
    fetchNext()
  }

  func didSelect(item: PokemonListItemViewModel) {
    os_log("PokemonListViewModel didSelect %@", log: Log.general, type: .info, item.identifier.rawValue)
  }

  // MARK: - Output -

  private let viewStateRelay = MutableObservable<PokemonListViewState>(value: .empty)
  var viewState: Observable<PokemonListViewState> { viewStateRelay }
}
