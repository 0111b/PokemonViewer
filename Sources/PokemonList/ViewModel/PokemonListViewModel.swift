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

  }

  // MARK: - Input -
  func viewDidLoad() {

  }

  // MARK: - Output -

  private let viewStateRelay = MutableObservable<PokemonListViewState>(value: .idle)
  var viewState: Observable<PokemonListViewState> { viewStateRelay }
}
