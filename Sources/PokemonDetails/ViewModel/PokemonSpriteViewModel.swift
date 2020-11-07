//
//  PokemonSpriteViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import UIKit
import os.log

final class PokemonSpriteViewModel {
  typealias Dependency = ImageService

  init(dependency: Dependency, sprite: PokemonSprite) {
    self.dependency = dependency
    self.sprite = sprite
  }

  private let dependency: Dependency
  private let sprite: PokemonSprite

  private var imageRequest: Disposable?

  // MARK: - Input -

  func fetchImage() {
    imageRelay.value = .loading
    imageRequest = dependency.image(url: sprite.url,
                                    cachePolicy: .cacheFirst,
                                    adapter: RequestAdapter()) { [weak self] result in
      guard let self = self else { return }
      let image: UIImage?
      switch result {
      case .success(let resultImage):
        image = resultImage
      case .failure(let error):
        os_log("PokemonSpriteViewModel image %{public}@ error %@", log: Log.general,
               type: .error, String(describing: self.kind), String(describing: error))
        image = Images.defaultPlaceholder
      }
      self.imageRelay.value = .image(image)
    }
  }

  // MARK: - Output -

  private let imageRelay = MutableObservable<RemoteImageViewState>(value: .empty)
  var image: Observable<RemoteImageViewState> { imageRelay }
  var kind: PokemonSprite.Kind { sprite.kind }
}
