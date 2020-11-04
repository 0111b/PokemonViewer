//
//  PokemonListViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import Foundation
import os.log

protocol PokemonListViewModelCoordinating: class {
  func showDetails(for identifier: Identifier<Pokemon>)
}

final class PokemonListViewModel {
  typealias Dependency = PokemonAPIServiceProvider & ImageServiceProvider

  init(dependency: Dependency, coordinator: PokemonListViewModelCoordinating) {
    self.dependency = dependency
    self.coordinator = coordinator
  }

  private let dependency: Dependency
  private weak var coordinator: PokemonListViewModelCoordinating?

  @Protected
  private var state = PokemonListState.empty

  private func update(_ closure: (inout PokemonListState) -> Void) {
    $state.write { state in
      var updatedState = state
      closure(&updatedState)
      if updatedState != state {
        viewStateRelay.value = updatedState.viewState
      }
      state = updatedState
    }
  }

  private func fetch(userInitiated: Bool, reload: Bool) {
    update { state in
      guard state.canStartRequest(forced: userInitiated) else { return }
      guard let page = reload ? PokemonListState.firstPage : state.nextPage else { return }
      let cachePolicy: RequestCachePolicy = userInitiated ? .networkFirst : .cacheFirst
      os_log("PokemonListViewModel fetch %@ %@", log: Log.general, type: .info,
             String(describing: page), String(describing: cachePolicy))
      let pageRequest = dependency.pokemonAPIService
        .list(page: page, cachePolicy: cachePolicy, completion: didLoad(page: page))
      state = state.with(pageRequest: pageRequest)
    }
  }

  private func didLoad(page: Page) -> (NetworkResult<PokemonAPI.PokemonPage>) -> Void {{ [weak self] result in
    guard let self = self else { return }
    self.update { state in
      switch result {
      case .failure(let error):
        os_log("PokemonListViewModel fetch error %@", log: Log.general, type: .error, String(describing: error))
        state = state.with(error: error)
      case .success(let pageData):
        let newItems = pageData.items.map { PokemonListItemViewModel(dependency: self.dependency, id: $0) }
        let items = page.isFirst ? newItems : state.items + newItems
        let listData = PokemonListState.ListData(items: items,
                                                 count: pageData.count,
                                                 page: page)
        state = state.with(list: listData)
      }
    }
  }}

  // MARK: - Input -

  func viewDidLoad() {
    os_log("PokemonListViewModel viewDidLoad", log: Log.general, type: .info)
    fetch(userInitiated: false, reload: false)
  }

  func askForNextPage() {
    fetch(userInitiated: false, reload: false)
  }

  func retry() {
    fetch(userInitiated: true, reload: false)
  }

  func refresh() {
    fetch(userInitiated: true, reload: true)
  }

  func didSelect(item: PokemonListItemViewModel) {
    os_log("PokemonListViewModel didSelect %@", log: Log.general, type: .info, item.identifier.rawValue)
    coordinator?.showDetails(for: item.identifier)
  }

  func toggleLayout() {
    self.update { state in
      state = state.with(layout: state.layout.toggle())
    }
  }

  // MARK: - Output -

  private let viewStateRelay = MutableObservable<PokemonListViewState>(value: .empty)
  var viewState: Observable<PokemonListViewState> { viewStateRelay }
}
