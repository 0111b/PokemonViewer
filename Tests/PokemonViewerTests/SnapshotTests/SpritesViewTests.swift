//
//  SpritesViewTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 10.11.2020.
//

import XCTest
@testable import PokemonViewer

final class SpritesViewTests: XCTestCase {

  var imageService: MockImageService!

  override func setUpWithError() throws {
    imageService = MockImageService()
    imageService.imageMock.returns(Disposable.empty)
    imageService.$imageResult.thenReturns(.success(Images.defaultPlaceholder!))
    imageService.$imageResult.thenReturns(.success(Images.defaultPlaceholder!))
    imageService.$imageResult.thenReturns(.success(Images.defaultPlaceholder!))
  }

  func testDefault() {
    let view = SpritesView()
    view.heightAnchor.constraint(equalToConstant: 200).isActive = true
    view.widthAnchor.constraint(equalToConstant: 500).isActive = true
    view.set(sprites: [
      PokemonSpriteViewModel(dependency: imageService, sprite: Stubs.sprite()),
      PokemonSpriteViewModel(dependency: imageService, sprite: Stubs.sprite())
    ])
    view.assertSnapshot()
  }
}
