//
//  NetworkServiceTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import XCTest
@testable import PokemonViewer

final class NetworkServiceTests: XCTestCase {

  var transport: MockHTTPTransport!
  var networkService: NetworkServiceImp!
  var cache: MockNetworkCache!
  let request = Stubs.request()

  override func setUpWithError() throws {
    cache = MockNetworkCache()
    transport = MockHTTPTransport()
    transport.obtainMock.returns(EmptyCancellable())
    cache.getMock.returns(nil)
    networkService = NetworkServiceImp(transport: transport, cache: cache)
  }

  func assertCache(didSet: Bool, didGet: Bool, network: Bool) {
    wait(for: [
      self.expectation(with: cache, keyPath: \.setMock.called, toBe: didSet),
      self.expectation(with: cache, keyPath: \.getMock.called, toBe: didGet),
      self.expectation(with: transport, keyPath: \.obtainMock.called, toBe: network)
    ], timeout: Stubs.assertInterval)
  }

  func assertSuccess(data: Data) -> (NetworkResult<Data>) -> Void {{ result in
    guard case .success(let resultData) = result else {
      XCTFail("Success expected")
      return
    }
    XCTAssertEqual(data, resultData)
  }}

  func assertFailure() -> (NetworkResult<Data>) -> Void {{ result in
    if case .success = result {
      XCTFail("Failure expected")
    }
  }}

  func testNetworkSuccess() {
    let data = Stubs.data()
    transport.thenObtain(data: data)

    _ = networkService.fetch(request: request,
                             cachePolicy: .networkOnly,
                             completion: assertSuccess(data: data))

    let (req, _) = transport.obtainMock.input
    XCTAssertEqual(req.urlRequest, request.urlRequest)
    assertCache(didSet: true, didGet: false, network: true)
  }

  func testNetworkFailure() {
    transport.thenObtain(error: .badRequest)

    _ = networkService.fetch(request: request, cachePolicy: .networkOnly, completion: assertFailure())

    assertCache(didSet: false, didGet: false, network: true)
  }

  func testNetworkFirstSuccess() {
    let data = Stubs.data()
    transport.thenObtain(data: data)

    _ = networkService.fetch(request: request,
                             cachePolicy: .networkFirst,
                             completion: assertSuccess(data: data))

    let (req, _) = transport.obtainMock.input
    XCTAssertEqual(req.urlRequest, request.urlRequest)

    assertCache(didSet: true, didGet: false, network: true)
  }

  func testNetworkFirstSuccessCache() {
    let response = Stubs.cachedResponse()
    cache.getMock.returns(response)
    transport.thenObtain(error: .badRequest)

    _ = networkService.fetch(request: request,
                             cachePolicy: .networkFirst,
                             completion: assertSuccess(data: response.data))

    assertCache(didSet: false, didGet: true, network: true)
  }

  func testNetworkFirstFailure() {
    transport.thenObtain(error: .badRequest)
    cache.getMock.returns(nil)

    _ = networkService.fetch(request: request,
                             cachePolicy: .networkFirst,
                             completion: assertFailure())

    assertCache(didSet: false, didGet: true, network: true)

  }

  func testCacheFirstSuccess() {
    transport.thenObtain(error: .badRequest)
    let response = Stubs.cachedResponse()
    cache.getMock.returns(response)

    _ = networkService.fetch(request: request,
                             cachePolicy: .cacheFirst,
                             completion: assertSuccess(data: response.data))

    assertCache(didSet: false, didGet: true, network: false)
  }

  func testCacheFirstSuccessNetwork() {
    let data = Stubs.data()
    transport.thenObtain(data: data)
    cache.getMock.returns(nil)

    _ = networkService.fetch(request: request,
                             cachePolicy: .cacheFirst,
                             completion: assertSuccess(data: data))

    assertCache(didSet: true, didGet: true, network: true)

  }

  func testCacheFirstFailure() {
    transport.thenObtain(error: .badRequest)
    cache.getMock.returns(nil)

    _ = networkService.fetch(request: request,
                             cachePolicy: .networkFirst,
                             completion: assertFailure())

    assertCache(didSet: false, didGet: true, network: true)

  }
}
