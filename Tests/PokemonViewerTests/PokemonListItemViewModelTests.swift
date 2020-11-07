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
  var collector: ObservableCollector<RemoteImageViewState>!

  override func setUpWithError() throws {
    dependency = MockDependency()
    viewModel = PokemonListItemViewModel(dependency: dependency, id: .init(rawValue: "pokemon"))
    dependency.mockPokemonAPIService.detailsMock.returns(Disposable.empty)
    dependency.mockImageService.imageMock.returns(Disposable.empty)
    collector = ObservableCollector(observable: viewModel.image, skipCurrent: true)
  }

  func testInitialValues() {
    XCTAssertEqual(viewModel.image.value, .empty)
  }

  func testDetailsError() {
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.failure(.badRequest))

    viewModel.willDisplay()

    assertViewState(image: [.image(UIImage())])
  }

  func testNoSprites() {
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.success(Stubs.pokemon(sprites: [])))
    dependency.mockImageService.$imageResult.thenReturns(.failure(.badRequest))

    viewModel.willDisplay()

    assertViewState(image: [])
  }

  func testImageError() {
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.success(Stubs.pokemon(sprites: [Stubs.sprite()])))
    dependency.mockImageService.$imageResult.thenReturns(.failure(.badRequest))

    viewModel.willDisplay()

    assertViewState(image: [])
  }

  func testSuccess() {
    let image = UIImage()
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.success(Stubs.pokemon(sprites: [Stubs.sprite()])))
    dependency.mockImageService.$imageResult.thenReturns(.success(image))

    viewModel.willDisplay()

    assertViewState(image: [.image(image)])
  }

  func assertViewState(image: [RemoteImageViewState]) {
    let expectation = self.expectation(with: collector, keyPath: \.values, toBe: image)
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
