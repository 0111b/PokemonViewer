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
  var collector: ObservableCollector<PokemonListItemViewState>!

  override func setUpWithError() throws {
    dependency = MockDependency()
    viewModel = PokemonListItemViewModel(dependency: dependency, id: .init(rawValue: "pokemon"))
    dependency.mockPokemonAPIService.detailsMock.returns(Disposable.empty)
    dependency.mockImageService.imageMock.returns(Disposable.empty)
    collector = ObservableCollector(observable: viewModel.viewState, skipCurrent: true)
  }

  func testInitialValues() {
    XCTAssertEqual(viewModel.viewState.value, .empty)
  }

  func testDetailsError() {
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.failure(.badRequest))

    viewModel.willDisplay()

    assert(states: [
      state(typeColors: [], hasNoImage: false, image: .loading),
      state(typeColors: [], hasNoImage: true, image: .image(UIImage()))
    ])
  }

  func testNoSprites() {
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.success(Stubs.pokemon(sprites: [])))
    dependency.mockImageService.$imageResult.thenReturns(.failure(.badRequest))

    viewModel.willDisplay()

    assert(states: [
      state(typeColors: [], hasNoImage: false, image: .loading),
      state(typeColors: [], hasNoImage: true, image: .image(UIImage()))
    ])
  }

  func testImageError() {
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.success(Stubs.pokemon(sprites: [Stubs.sprite()])))
    dependency.mockImageService.$imageResult.thenReturns(.failure(.badRequest))

    viewModel.willDisplay()

    assert(states: [
      state(typeColors: [], hasNoImage: false, image: .loading),
      state(typeColors: [], hasNoImage: false, image: .loading),
      state(typeColors: [], hasNoImage: true, image: .image(UIImage()))
    ])
  }

  func testSuccess() {
    let image = UIImage()
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.success(Stubs.pokemon(sprites: [Stubs.sprite()])))
    dependency.mockImageService.$imageResult.thenReturns(.success(image))

    viewModel.willDisplay()

    assert(states: [
      state(typeColors: [], hasNoImage: false, image: .loading),
      state(typeColors: [], hasNoImage: false, image: .loading),
      state(typeColors: [], hasNoImage: false, image: .image(image))
    ])
  }

  private func state(typeColors: [UIColor], hasNoImage: Bool, image: RemoteImageViewState) -> PokemonListItemViewState {
    PokemonListItemViewState(title: "Pokemon", typeColors: typeColors, hasNoImage: hasNoImage, image: image)
  }

  func assert(states: [PokemonListItemViewState]) {
    let expectation = self.expectation(with: collector, keyPath: \.values, toBe: states)
    wait(for: [expectation], timeout: Stubs.assertInterval)
    collector.reset()
  }

}

extension RemoteImageViewState: Equatable {
  public static func == (lhs: RemoteImageViewState, rhs: RemoteImageViewState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading),
         (.image(_?), image(_?)),
         (.image(nil), image(nil)):
      return true
    default:
      return false
    }
  }
}

extension PokemonListItemViewState: Equatable {
  public static func == (lhs: PokemonListItemViewState, rhs: PokemonListItemViewState) -> Bool {
    lhs.title == rhs.title
      && lhs.typeColors == rhs.typeColors
      && lhs.hasNoImage == rhs.hasNoImage
      && lhs.image == rhs.image
  }

}
