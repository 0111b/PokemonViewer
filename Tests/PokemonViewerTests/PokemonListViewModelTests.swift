//
//  PokemonListViewModelTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import XCTest
@testable import PokemonViewer

final class PokemonListViewModelTests: XCTestCase {

  var viewModel: PokemonListViewModel!
  var dependency: MockDependency!
  var coordinator: MockPokemonListViewModelCoordinator!

  override func setUpWithError() throws {
    dependency = MockDependency()
    coordinator = MockPokemonListViewModelCoordinator()
    viewModel = PokemonListViewModel(dependency: dependency, coordinator: coordinator)
    dependency.mockPokemonAPIService.listMock.returns(Disposable.empty)
  }


  func testInitialValues() {
    XCTAssertEqual(viewModel.viewState.value.layout, .list)
    XCTAssertEqual(viewModel.viewState.value.loading, .clear)
    XCTAssertTrue(viewModel.viewState.value.items.isEmpty)
  }

  func testViewDidLoad() {
    dependency.mockPokemonAPIService.$listResult.thenReturns(failedResponse())
    let collector = ObservableCollector(observable: viewModel.viewState, skipCurrent: true)

    viewModel.viewDidLoad()
    
    XCTAssertEqual(collector.values.map(\.loading), [.loading])

  }

  func failedResponse() -> NetworkResult<PokemonAPI.PokemonPage> {
    .failure(.badRequest)
  }
}


final class MockPokemonListViewModelCoordinator: PokemonListViewModelCoordinating {

  public lazy var showDetailsMock = MockFunc.mock(for: self.showDetails(for:))
  func showDetails(for identifier: Identifier<Pokemon>) {
    showDetailsMock.call(with: identifier)
  }

}
