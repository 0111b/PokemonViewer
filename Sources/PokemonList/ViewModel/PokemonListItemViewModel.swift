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
        os_log("PokemonListItemViewModel details %{public}@ error %@", log: Log.general,
               type: .error, self.identifier.rawValue, String(describing: error))
        self.didFailToFetchImage()
        self.state = .idle
      case .success(let pokemon):
        if let url = pokemon.sprites.first?.url {
          self.state = .imageRequest(self.fetchImage(url: url))
        } else {
          self.didFailToFetchImage()
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
        os_log("PokemonListItemViewModel image %{public}@ error %@", log: Log.general,
               type: .error, self.identifier.rawValue, String(describing: error))
        self.didFailToFetchImage()
        self.state = .idle
      case .success(let image):
        self.imageRelay.value = .image(image)
        self.state = .done
      }
    }
  }

  private func didFailToFetchImage() {
    self.imageRelay.value = .image(Images.defaultPlaceholder)
  }

  // MARK: - Input -

  func willDisplay() {
    $state.write { state in
      guard state.canStartRequest else { return }
      imageRelay.value = .loading
      state = .detailsRequest(fetchDetails())
    }
  }

  func didEndDisplaying() {
    $state.write { state in
      state = state.canceled()
    }
  }

  // MARK: - Output -

  let identifier: Identifier<Pokemon>
  var title: String { identifier.rawValue.capitalized }
  private let imageRelay = MutableObservable<RemoteImageViewState>(value: .empty)
  var image: Observable<RemoteImageViewState> { imageRelay }
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
