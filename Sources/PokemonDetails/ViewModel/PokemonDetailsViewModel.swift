//
//  PokemonDetailsViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import Foundation

final class PokemonDetailsViewModel {
  typealias Dependency = PokemonAPIServiceProvider

  init(dependency: Dependency, identifier: Identifier<Pokemon>) {
    self.dependency = dependency
    self.identifier = identifier
  }

  private let dependency: Dependency

  @Protected
  private var state: PokemonDetailsState = .idle {
    didSet {
      pokemonRelay.value = state.viewState
    }
  }

  private func fetch() {
    state = .loading(
      dependency.pokemonAPIService.details(for: identifier,
                                           cachePolicy: .cacheFirst) { [weak self] result in
        let newState: PokemonDetailsState
        switch result {
        case .failure(let error): newState = .error(error)
        case .success(let pokemon): newState = .done(pokemon)
        }
        self?.state = newState
      })
  }


  // MARK: - Input -

  func retry() {
    fetch()
  }

  func viewDidLoad() {
    fetch()
  }

  // MARK: - Output -

  let identifier: Identifier<Pokemon>
  private let pokemonRelay = MutableObservable<PokemonDetailsViewState>(value: .idle)
  var pokemon: Observable<PokemonDetailsViewState> { pokemonRelay }

}
