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
    let page = viewStateRelay.value.currentPage ?? Page(limit: 42)
    pageRequest = pokemonAPIService.list(page: page, cachePolicy: .cacheFirst) { [weak self] result in
      guard let self = self else { return }
      self.pageRequest = nil
      Swift.print(result)
      if case .success(let page) = result {
        let identifier = page.items[Int.random(in: page.items.indices)]
        self.details = self.pokemonAPIService.details(for: identifier, cachePolicy: .networkFirst) { detailsResult in
          Swift.print(detailsResult)
        }
      }
    }
  }

// REMOVE
  private var details: Disposable?


  // MARK: - Input -
  func viewDidLoad() {
    fetch()
  }

  // MARK: - Output -

  private let viewStateRelay = MutableObservable<PokemonListViewState>(value: .idle)
  var viewState: Observable<PokemonListViewState> { viewStateRelay }
}
