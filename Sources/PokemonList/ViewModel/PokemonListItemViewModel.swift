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

  private var detailsRequest: Disposable?
  private var imageRequest: Disposable?

  // MARK: - Input -

  func willDisplay() {
    os_log("PokemonListItemViewModel willDisplay %@", log: Log.general, type: .debug, identifier.rawValue)
    guard imageRelay.value == nil else { return }
    // check progress
    detailsRequest = dependency.pokemonAPIService
      .details(for: identifier, cachePolicy: .cacheFirst) { [weak self] pokemonResult in
        guard let self = self else { return }
        switch pokemonResult {
        case .failure(let error):
          os_log("PokemonListItemViewModel details error %@", log: Log.general,
                 type: .error, String(describing: error))
        case .success(let pokemon):
          guard let url = pokemon.sprites.first else { return }
          self.imageRequest = self.dependency.imageService.image(url: url,
                                                                 cachePolicy: .cacheFirst,
                                                                 adapter: RequestAdapter()) { [weak self] imageResult in
            switch imageResult {
            case .failure(let error):
              os_log("PokemonListItemViewModel image error %@", log: Log.general,
                     type: .error, String(describing: error))
            case .success(let image):
              self?.imageRelay.value = image
            }
          }
        }
    }
  }

  func didEndDisplaying() {
    os_log("PokemonListItemViewModel didEndDisplaying %@", log: Log.general, type: .debug, identifier.rawValue)
    detailsRequest = nil
    imageRequest = nil
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
