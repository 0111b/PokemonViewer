//
//  PokemonListViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import Foundation

final class PokemonListViewModel {
  typealias Dependency = PokemonAPIServiceProvider & ImageServiceProvider

  init(dependency: Dependency) {
    self.dependency = dependency
  }

  private let dependency: Dependency

  private var state = PokemonListState.idle {
    didSet {
      viewStateRelay.value = state.viewState
    }
  }

  @Protected
  private var pageRequest: Disposable?

  private func fetch() {
    guard pageRequest == nil else { return }
    let page =  Page(limit: 5)
    pageRequest = dependency.pokemonAPIService.list(page: page, cachePolicy: .cacheFirst) { [weak self] result in
      guard let self = self else { return }
      self.pageRequest = nil
      switch result {
      case .failure(let error):
        Swift.print(error)
      case .success(let pageData):
        // append
        // check page
        let viewModels = pageData.items.map { PokemonListItemViewModel(dependency: self.dependency, id: $0) }
        let listData = PokemonListState.ListData(items: viewModels,
                                                 count: pageData.count,
                                                 page: page)
        self.state = .data(listData)
      }
    }
  }


  // MARK: - Input -

  func viewDidLoad() {
    fetch()
  }

  func didSelect(item: PokemonListItemViewModel) {
    
  }

  // MARK: - Output -

  private let viewStateRelay = MutableObservable<PokemonListViewState>(value: .empty)
  var viewState: Observable<PokemonListViewState> { viewStateRelay }
}
