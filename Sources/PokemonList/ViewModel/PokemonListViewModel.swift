//
//  PokemonListViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import Foundation

final class PokemonListViewModel {
  typealias Dependency = PokemonAPIServiceProvider

  init(dependency: Dependency) {
    pokemonAPIService = dependency.pokemonAPIService
  }

  private let pokemonAPIService: PokemonAPIService
  private var pageRequest: Disposable?

  private func fetch() {
    // guard pageRequest
    let page = viewStateRelay.value.currentPage ?? PokemonAPI.Page(limit: 42)
    pageRequest = pokemonAPIService.list(page: page, cachePolicy: .cacheFirst) { [weak self] result in
      self?.pageRequest = nil
      Swift.print(result)

    }
  }

  // MARK: - Input -
  func viewDidLoad() {
    fetch()
  }

  // MARK: - Output -

  private let viewStateRelay = MutableObservable<PokemonListViewState>(value: .idle)
  var viewState: Observable<PokemonListViewState> { viewStateRelay }
}
