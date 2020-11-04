//
//  PokemonListItemViewModelTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import XCTest
@testable import PokemonViewer

final class PokemonListItemViewModelTests: XCTestCase {

  var viewModel: PokemonListItemViewModel!
  var dependency: MockDependency!
  var collector: ObservableCollector<UIImage?>!

  override func setUpWithError() throws {
    dependency = MockDependency()
    viewModel = PokemonListItemViewModel(dependency: dependency, id: .init(rawValue: "pokemon"))
    dependency.mockPokemonAPIService.detailsMock.returns(Disposable.empty)
    dependency.mockImageService.imageMock.returns(Disposable.empty)
    collector = ObservableCollector(observable: viewModel.image, skipCurrent: true)
  }

  func testInitialValues() {
    XCTAssertNil(viewModel.image.value)
  }

  func testDetailsError() {
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.failure(.badRequest))

    viewModel.willDisplay()

    assertViewState(image: [])
  }

  func testNoSprites() {
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.success(pokemon(sprites: [])))
    dependency.mockImageService.$imageResult.thenReturns(.failure(.badRequest))

    viewModel.willDisplay()

    assertViewState(image: [])
  }

  func testImageError() {
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.success(pokemon(sprites: [sprite()])))
    dependency.mockImageService.$imageResult.thenReturns(.failure(.badRequest))

    viewModel.willDisplay()

    assertViewState(image: [])
  }

  func testSuccess() {
    let image = UIImage()
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.success(pokemon(sprites: [sprite()])))
    dependency.mockImageService.$imageResult.thenReturns(.success(image))

    viewModel.willDisplay()

    assertViewState(image: [image])
  }

  func assertViewState(image: [UIImage?]) {
    let expectation = self.expectation(with: collector, keyPath: \.values, toBe: image)
    wait(for: [expectation], timeout: 4)
  }

  func pokemon(sprites: [PokemonSprite]) -> Pokemon {
    Pokemon(id: .init(rawValue: "123"),
            height: 1,
            weight: 1,
            sprites: sprites,
            stats: [],
            abilities: [],
            types: [])
  }

  func sprite() -> PokemonSprite {
    PokemonSprite(url: Stubs.url(), kind: .frontDefault)
  }
}
