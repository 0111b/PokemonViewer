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
   identifier = id
    self.dependency = dependency
  }

  private let dependency: Dependency

  @Protected
  private var state: PokemonListItemState = .idle

  private func fetchDetails() -> Disposable {
    dependency.pokemonAPIService.details(for: identifier, cachePolicy: .cacheFirst) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .failure(let error):
        os_log("PokemonListItemViewModel details %@ error %@", log: Log.general,
               type: .error, self.identifier.rawValue, String(describing: error))
        self.state = .idle
      case .success(let pokemon):
        if let url = pokemon.sprites.first {
          self.state = .imageRequest(self.fetchImage(url: url))
        } else {
          self.state = .done
        }
      }
    }
  }

  private func fetchImage(url: URL) -> Disposable {
    dependency.imageService.image(url: url,
                                  cachePolicy: .cacheFirst,
                                  adapter: RequestAdapter()) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .failure(let error):
        os_log("PokemonListItemViewModel image %@ error %@", log: Log.general,
               type: .error, self.identifier.rawValue, String(describing: error))
        self.state = .idle
      case .success(let image):
        self.imageRelay.value = image
        self.state = .done
      }
    }
  }

  // MARK: - Input -

  func willDisplay() {
    os_log("PokemonListItemViewModel willDisplay %@", log: Log.general, type: .debug, identifier.rawValue)
    $state.write { state in
      guard state.canStartRequest else { return }
      state = .detailsRequest(fetchDetails())
    }
  }

  func didEndDisplaying() {
    os_log("PokemonListItemViewModel didEndDisplaying %@", log: Log.general, type: .debug, identifier.rawValue)
    $state.write { state in
      state = state.canceled()
    }
  }

  // MARK: - Output -

  let identifier: Identifier<Pokemon>
  var title: String { identifier.rawValue }
  private let imageRelay = MutableObservable<UIImage?>(value: nil)
  var image: Observable<UIImage?> { imageRelay }
}

extension PokemonListItemViewModel: Equatable {
  static func == (lhs: PokemonListItemViewModel, rhs: PokemonListItemViewModel) -> Bool {
    lhs.identifier == rhs.identifier
  }
}

extension PokemonListItemViewModel: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
}
