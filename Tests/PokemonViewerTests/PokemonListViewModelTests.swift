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
  var collector: ObservableCollector<PokemonListViewState>!

  override func setUpWithError() throws {
    dependency = MockDependency()
    coordinator = MockPokemonListViewModelCoordinator()
    viewModel = PokemonListViewModel(dependency: dependency, coordinator: coordinator)
    dependency.mockPokemonAPIService.listMock.returns(Disposable.empty)
    collector = ObservableCollector(observable: viewModel.viewState, skipCurrent: true)
  }

  func testInitialValues() {
    XCTAssertEqual(viewModel.viewState.value.layout, .list)
    XCTAssertEqual(viewModel.viewState.value.loading, .clear)
    XCTAssertTrue(viewModel.viewState.value.items.isEmpty)
  }

  func testLayoutSwitch() {
    viewModel.toggleLayout()
    viewModel.toggleLayout()

    assertViewState(layout: [.grid, .list])
  }

  func testSelectItem() {
    let pokemon = Identifier<Pokemon>(rawValue: Stubs.string())

    viewModel.didSelect(item: PokemonListItemViewModel(dependency: dependency, id: pokemon))

    XCTAssertEqual(coordinator.showDetailsMock.input, pokemon)
  }

  func testFirstPageError() {
    dependency.mockPokemonAPIService.$listResult.thenReturns(failedResponse())

    viewModel.viewDidLoad()

    assertViewState(loading: [.loading, .hint("")],
                    items: [[], []])
    assert(cachePolicy: [.cacheFirst])
    assert(pages: [PokemonListState.firstPage])
  }

  func testFirstPageSuccess() {
    let responses = responseIterator(count: 2)
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())

    viewModel.viewDidLoad()

    assertViewState(loading: [.loading, .clear],
                    items: [[], ["1"]])
    assert(cachePolicy: [.cacheFirst])
    assert(pages: [PokemonListState.firstPage])
  }

  func testSinglePage() {
    let responses = responseIterator(count: 1)
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())

    viewModel.viewDidLoad()

    assertViewState(loading: [.loading, .hint("")],
                    items: [[], ["1"]])
    assert(cachePolicy: [.cacheFirst])
    assert(pages: [PokemonListState.firstPage])

  }

  func testNextPage() {
    let responses = responseIterator(count: 3)
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())

    viewModel.viewDidLoad()
    assertViewState(loading: [.loading, .clear])

    viewModel.askForNextPage()

    assertViewState(loading: [.loading, .clear],
                    items: [["1"], ["1", "2"]])
    assert(cachePolicy: [.cacheFirst, .cacheFirst])
    assert(pages: [PokemonListState.firstPage, PokemonListState.firstPage.next()])
  }

  func testLastPage() {
    let responses = responseIterator(count: 2)
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())

    viewModel.viewDidLoad()
    assertViewState(loading: [.loading, .clear])

    viewModel.askForNextPage()

    assertViewState(loading: [.loading, .hint("")],
                    items: [["1"], ["1", "2"]])
    assert(cachePolicy: [.cacheFirst, .cacheFirst])
    assert(pages: [PokemonListState.firstPage, PokemonListState.firstPage.next()])
  }

  func testNextPageError() {
    let responses = responseIterator(count: 2)
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())
    dependency.mockPokemonAPIService.$listResult.thenReturns(failedResponse())

    viewModel.viewDidLoad()
    assertViewState(loading: [.loading, .clear])

    viewModel.askForNextPage()

    assertViewState(loading: [.loading, .hint("")],
                    items: [["1"], ["1"]])
    assert(cachePolicy: [.cacheFirst, .cacheFirst])
    assert(pages: [PokemonListState.firstPage, PokemonListState.firstPage.next()])
  }

  func testRetryFirstPage() {
    let responses = responseIterator(count: 2)
    dependency.mockPokemonAPIService.$listResult.thenReturns(failedResponse())
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())

    viewModel.viewDidLoad()
    assertViewState(loading: [.loading, .hint("")])

    viewModel.retry()

    assertViewState(loading: [.loading, .clear],
                    items: [[], ["1"]])


    assert(cachePolicy: [.cacheFirst, .networkFirst])
    assert(pages: [PokemonListState.firstPage, PokemonListState.firstPage])
  }

  func testRetryNextpage() {
    let responses = responseIterator(count: 5)
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())
    dependency.mockPokemonAPIService.$listResult.thenReturns(failedResponse())
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())

    viewModel.viewDidLoad()
    assertViewState(loading: [.loading, .clear])
    viewModel.askForNextPage()
    assertViewState(loading: [.loading, .hint("")])

    viewModel.retry()

    assertViewState(loading: [.loading, .clear],
                    items: [["1"], ["1", "2"]])
    assert(cachePolicy: [.cacheFirst, .cacheFirst, .networkFirst])
    assert(pages: [PokemonListState.firstPage, PokemonListState.firstPage.next(), PokemonListState.firstPage.next()])
  }

  func testRefresh() {
    let responses = responseIterator(count: 5)
    let responses2 = responseIterator(count: 5)
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses2())

    viewModel.viewDidLoad()
    assertViewState(loading: [.loading, .clear])
    viewModel.askForNextPage()
    assertViewState(loading: [.loading, .clear])

    viewModel.refresh()

    assertViewState(loading: [.loading, .clear],
                    items: [["1", "2"], ["1"]])
    assert(cachePolicy: [.cacheFirst, .cacheFirst, .networkFirst])
    assert(pages: [PokemonListState.firstPage, PokemonListState.firstPage.next(), PokemonListState.firstPage])
  }

  func testIgnoreMultipleRequests() {
    let responses = responseIterator(count: 5)
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())

    viewModel.viewDidLoad()
    assertViewState(loading: [.loading, .clear])

    viewModel.askForNextPage()
    viewModel.askForNextPage()

    assertViewState(loading: [.loading, .clear],
                    items: [["1"], ["1", "2"]])
    assert(cachePolicy: [.cacheFirst, .cacheFirst])
    assert(pages: [PokemonListState.firstPage, PokemonListState.firstPage.next()])
  }

  func testNameFilter() {
    let responses = responseIterator(count: 5)
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())
    dependency.mockPokemonAPIService.$listResult.thenReturns(responses())

    viewModel.viewDidLoad()
    assertViewState(loading: [.loading, .clear])
    viewModel.askForNextPage()
    assertViewState(loading: [.loading, .clear],
                    items: [["1"], ["1", "2"]])

    viewModel.didChangeNameFilter(name: "2")
    assertViewState(loading: [.clear],
                    items: [["2"]])

  }

  // MARK: - Asserts

  func failedResponse() -> NetworkResult<PokemonAPI.PokemonPage> {
    let responses = responseIterator(count: 0)
    return responses()
  }

  func responseIterator(count: Int) -> () -> NetworkResult<PokemonAPI.PokemonPage> {
    var page = 0
    return {
      page += 1
      if page <= count {
        return .success(PokemonAPI.PokemonPage(count: count * Int(PokemonListState.firstPage.limit),
                                               items: [
                                                Identifier<Pokemon>(rawValue: String(page))
                                               ]))
      } else {
        return .failure(.badRequest)
      }
    }
  }

  func assert(cachePolicy: [RequestCachePolicy]) {
    let parameters = dependency.mockPokemonAPIService.listMock.parameters
    let resultPolicies: [RequestCachePolicy] = parameters.map { params in
      let (_, cachePolicy, _) = params
      return cachePolicy
    }
    XCTAssertEqual(resultPolicies, cachePolicy)
  }

  func assert(pages: [Page]) {
    let parameters = dependency.mockPokemonAPIService.listMock.parameters
    let resultPages: [Page] = parameters.map { params in
      let (page, _, _) = params
      return page
    }
    XCTAssertEqual(resultPages, pages)
  }

  func assertViewState(loading: [PageLoadingViewState]? = nil,
                       layout: [PokemonListLayout]? = nil,
                       items: [[String]]? = nil) {

    var expectations = [XCTestExpectation]()
    if let loading = loading {
      let expectation = self.expectation(with: collector,
                                         transform: { $0.values.map(\.loading) },
                                         toBe: loading)
      expectations.append(expectation)
    }

    if let layout = layout {
      let expectation = self.expectation(with: collector,
                                         transform: { $0.values.map(\.layout) },
                                         toBe: layout)
      expectations.append(expectation)
    }

    if let items = items {
      let expectation = self.expectation(with: collector,
                                         transform: { collector in
                                          collector.values
                                            .map(\.items)
                                            .map { viewModel in
                                              viewModel.map(\.identifier.rawValue)
                                            }
                                         },
                                         toBe: items)
      expectations.append(expectation)
    }

    wait(for: expectations, timeout: Stubs.assertInterval)
    collector.reset()
  }
}


final class MockPokemonListViewModelCoordinator: PokemonListViewModelCoordinating {

  public lazy var showDetailsMock = MockFunc.mock(for: self.showDetails(for:))
  func showDetails(for identifier: Identifier<Pokemon>) {
    showDetailsMock.call(with: identifier)
  }

}

extension PageLoadingViewState: Equatable {
  public static func == (lhs: PageLoadingViewState, rhs: PageLoadingViewState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading), (.clear, .clear), (.hint, .hint):
      return true
    default:
      return false
    }
  }
}
