//
//  PokemonListItemViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import UIKit
import os.log

final class PokemonListItemViewModel {
  typealias Dependency = PokemonAPIServiceProvider & ImageServiceProvider

  init(dependency: Dependency, id: Identifier<Pokemon>) {
    state = PokemonListItemState(id: id)
    self.dependency = dependency
  }

  private let dependency: Dependency

  @Protected
  private var state: PokemonListItemState

  private func update(_ closure: (inout PokemonListItemState) -> Void) {
    $state.write { state in
      var updatedState = state
      closure(&updatedState)
      viewStateRelay.value = updatedState.viewState
      state = updatedState
    }
  }

  private func fetchDetails(identifier: Identifier<Pokemon>) -> Disposable {
    dependency.pokemonAPIService.details(for: identifier, cachePolicy: .cacheFirst) { [weak self] result in
      guard let self = self else { return }
      self.update { state in
        switch result {
        case .failure(let error):
          os_log("PokemonListItemViewModel details %{public}@ error %@", log: Log.general,
                 type: .error, state.identifier.rawValue, String(describing: error))
          state = state.with(detailsError: error)
        case .success(let pokemon):
          if let url = pokemon.sprites.first?.url {
            state = state.with(imageRequest: self.fetchImage(url: url), types: pokemon.types)
          } else {
            state = state.with(detailsError: .decodingError(nil))
          }
        }
      }
    }
  }

  private func fetchImage(url: URL) -> Disposable {
    dependency.imageService.image(url: url,
                                  cachePolicy: .cacheFirst,
                                  adapter: RequestAdapter()) { [weak self] result in
      self?.update { state in
        switch result {
        case .failure(let error):
          os_log("PokemonListItemViewModel image %{public}@ error %@", log: Log.general,
                 type: .error, state.identifier.rawValue, String(describing: error))
          state = state.with(imageError: error)
        case .success(let image):
          state = state.withImage(image: image)
        }
      }
    }
  }


  // MARK: - Input -

  func willDisplay() {
    update { state in
      guard state.canStartRequest() else { return }
      state = state.with(detailsRequest: fetchDetails(identifier: state.identifier))
    }
  }

  func didEndDisplaying() {
    update { state in
      state = state.canceled()
    }
  }

  func flushMemory() {
    update { state in
      state = state.flushMemory()
    }
  }

  // MARK: - Output -
  var identifier: Identifier<Pokemon> { state.identifier }
  private let viewStateRelay = MutableObservable<PokemonListItemViewState>(value: .empty)
  var viewState: Observable<PokemonListItemViewState> { viewStateRelay }
}

extension PokemonListItemViewModel: Equatable {
  static func == (lhs: PokemonListItemViewModel, rhs: PokemonListItemViewModel) -> Bool {
    lhs.state.identifier == rhs.state.identifier
  }
}
