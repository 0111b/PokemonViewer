//
//  PokemonListItemViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import UIKit

final class PokemonListItemViewModel {
  typealias Dependency = PokemonAPIServiceProvider & ImageServiceProvider

  init(dependency: Dependency, id: Identifier<Pokemon>) {
   identifier = id
    self.dependency = dependency
  }

  private let dependency: Dependency
  private let identifier: Identifier<Pokemon>

  private var detailsRequest: Disposable?
  private var imageRequest: Disposable?

  // MARK: - Input -

  func willDisplay() {
    guard imageRelay.value == nil else { return }
    detailsRequest = dependency.pokemonAPIService
      .details(for: identifier, cachePolicy: .cacheFirst) { [weak self] pokemonResult in
        guard case .success(let pokemon) = pokemonResult,
              let url = pokemon.sprites.first,
              let self = self
        else { return }
        self.imageRequest = self.dependency.imageService.image(url: url,
                                                               cachePolicy: .cacheFirst,
                                                               adapter: RequestAdapter()) { [weak self] imageResult in
          guard case .success(let image) = imageResult else { return }
          self?.imageRelay.value = image
        }
    }
  }

  func didEndDisplaying() {
    detailsRequest = nil
    imageRequest = nil
  }

  // MARK: - Output -

  var title: String { identifier.rawValue }
  private let imageRelay = MutableObservable<UIImage?>(value: nil)
  var image: Observable<UIImage?> { imageRelay }
}
