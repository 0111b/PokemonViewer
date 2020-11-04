//
//  PokemonDetailsViewModelTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import XCTest
@testable import PokemonViewer

final class PokemonDetailsViewModelTests: XCTestCase {

  var viewModel: PokemonDetailsViewModel!
  var dependency: MockDependency!
  var collector: ObservableCollector<PokemonDetailsViewState>!


  override func setUpWithError() throws {
    dependency = MockDependency()
    viewModel = PokemonDetailsViewModel(dependency: dependency, identifier: .init(rawValue: "pokemon"))
    dependency.mockPokemonAPIService.detailsMock.returns(Disposable.empty)
    collector = ObservableCollector(observable: viewModel.pokemon, skipCurrent: true)
  }

  func testInitialValues() {
    XCTAssertEqual(viewModel.pokemon.value, .idle)
  }

  func testDetailsError() {
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.failure(.badRequest))

    viewModel.viewDidLoad()

    assertView(state: [.loading, .error("")])
  }

  func testSuccess() {
    let pokemon = Stubs.pokemon(sprites: [Stubs.sprite()])
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.success(pokemon))

    viewModel.viewDidLoad()

    let details = PokemonDetails(pokemon: pokemon, sprites: [])
    assertView(state: [.loading, .data(details)])
  }

  func testRetry() {
    let pokemon = Stubs.pokemon(sprites: [Stubs.sprite()])
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.failure(.badRequest))
    dependency.mockPokemonAPIService.$detailsResult.thenReturns(.success(pokemon))

    viewModel.viewDidLoad()
    assertView(state: [.loading, .error("")])

    viewModel.retry()

    let details = PokemonDetails(pokemon: pokemon, sprites: [])
    assertView(state: [.loading, .data(details)])
  }

  func assertView(state: [PokemonDetailsViewState]) {
    let expectation = self.expectation(with: collector, keyPath: \.values, toBe: state)
    wait(for: [expectation], timeout: Stubs.assertInterval)
    collector.reset()
  }
}

extension PokemonDetailsViewState: Equatable {
  public static func == (lhs: PokemonDetailsViewState, rhs: PokemonDetailsViewState) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle), (.error, .error), (.loading, .loading):
      return true
    case let (.data(lhsData), .data(rhsData)):
      return lhsData.pokemon.id == rhsData.pokemon.id
    default:
      return false
    }
  }
}
