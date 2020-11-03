//
//  PokemonSpriteViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import UIKit

final class PokemonSpriteViewModel {
  typealias Dependency = ImageService

  init(dependency: Dependency, url: URL) {
    self.dependency = dependency
    self.url = url
  }

  private let dependency: Dependency
  private let url: URL

  private var imageRequest: Disposable?

  // MARK: - Input -

  func fetchImage() {
    imageRequest = dependency.image(url: url,
                                    cachePolicy: .cacheFirst,
                                    adapter: RequestAdapter()) { [weak self] result in
      guard case .success(let image) = result else { return }
      self?.imageRelay.value = image
    }
  }

  // MARK: - Output -

  private let imageRelay = MutableObservable<UIImage?>(value: nil)
  var image: Observable<UIImage?> { imageRelay }

}
