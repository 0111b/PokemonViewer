//
//  PokemonDetailsViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import Foundation

protocol PokemonDetailsViewModelCoordinating: AnyObject {
  func showSpriteLegend()
}

final class PokemonDetailsViewModel {
  typealias Dependency = PokemonAPIServiceProvider & ImageServiceProvider

  init(dependency: Dependency, coordinator: PokemonDetailsViewModelCoordinating, identifier: Identifier<Pokemon>) {
    self.dependency = dependency
    self.coordinator = coordinator
    self.identifier = identifier
  }

  private weak var coordinator: PokemonDetailsViewModelCoordinating?
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
        guard let self = self else { return }
        switch result {
        case .failure(let error):
          self.state = .error(error)
        case .success(let pokemon):
          let sprites = pokemon.sprites.map {
            PokemonSpriteViewModel(dependency: self.dependency.imageService, sprite: $0)
          }
          let details = PokemonDetails(pokemon: pokemon,
                                       sprites: sprites)
          self.state = .done(details)
        }
      })
  }


  // MARK: - Input -

  func retry() {
    fetch()
  }

  func viewDidLoad() {
    fetch()
  }

  func showSpriteLegend() {
    coordinator?.showSpriteLegend()
  }

  // MARK: - Output -

  let identifier: Identifier<Pokemon>
  private let pokemonRelay = MutableObservable<PokemonDetailsViewState>(value: .idle)
  var pokemon: Observable<PokemonDetailsViewState> { pokemonRelay }

}
