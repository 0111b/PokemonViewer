//
//  RequestAdapterTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import XCTest
@testable import PokemonViewer

final class RequestAdapterTests: XCTestCase {
  var request: URLRequest!
  var adapter: RequestAdapter!

  override func setUpWithError() throws {
    request = URLRequest(url: URL(string: "http://google.com")!)
    adapter = RequestAdapter()
  }

  func testInitialState() {
    XCTAssertTrue(adapter.modifiers.isEmpty)
  }

  func testAppend() {
    _ = adapter.append({ _ in })
    XCTAssertEqual(adapter.modifiers.count, 1)
  }

  func testApply() {
    var isUpdateCalled = false
    _ = adapter.append({ _ in
      isUpdateCalled = true
    })
    adapter.apply(to: &request)
    XCTAssertTrue(isUpdateCalled)
  }

  @available(iOS 13.0, *)
  func testAllowsExpensiveNetworkAccess() {
    _ = adapter.allowsExpensiveNetworkAccess(true)
    adapter.apply(to: &request)
    XCTAssertEqual(request.allowsExpensiveNetworkAccess, true)
    _ = adapter.allowsExpensiveNetworkAccess(false)
    adapter.apply(to: &request)
    XCTAssertEqual(request.allowsExpensiveNetworkAccess, false)
  }

  @available(iOS 13.0, *)
  func testAllowsConstrainedNetworkAccess() {
    _ = adapter.allowsConstrainedNetworkAccess(true)
    adapter.apply(to: &request)
    XCTAssertEqual(request.allowsConstrainedNetworkAccess, true)
    _ = adapter.allowsConstrainedNetworkAccess(false)
    adapter.apply(to: &request)
    XCTAssertEqual(request.allowsConstrainedNetworkAccess, false)
  }

  func testAllowsCellularAccess() {
    _ = adapter.allowsCellularAccess(true)
    adapter.apply(to: &request)
    XCTAssertEqual(request.allowsCellularAccess, true)
    _ = adapter.allowsCellularAccess(false)
    adapter.apply(to: &request)
    XCTAssertEqual(request.allowsCellularAccess, false)
  }

  func testCachePolicy() {
    _ = adapter.cachePolicy(.returnCacheDataDontLoad)
    adapter.apply(to: &request)
    XCTAssertEqual(request.cachePolicy, .returnCacheDataDontLoad)
    _ = adapter.cachePolicy(.useProtocolCachePolicy)
    adapter.apply(to: &request)
    XCTAssertEqual(request.cachePolicy, .useProtocolCachePolicy)
  }

  func testTimeoutInterval() {
    _ = adapter.timeoutInterval(42)
    adapter.apply(to: &request)
    XCTAssertEqual(request.timeoutInterval, 42)
  }

  func testNetworkServiceType() {
    _ = adapter.networkServiceType(.video)
    adapter.apply(to: &request)
    XCTAssertEqual(request.networkServiceType, .video)
  }

  func testHttpShouldHandleCookies() {
    _ = adapter.httpShouldHandleCookies(true)
    adapter.apply(to: &request)
    XCTAssertEqual(request.httpShouldHandleCookies, true)
    _ = adapter.httpShouldHandleCookies(false)
    adapter.apply(to: &request)
    XCTAssertEqual(request.httpShouldHandleCookies, false)
  }

  func testHttpShouldUsePipelining() {
    _ = adapter.httpShouldUsePipelining(true)
    adapter.apply(to: &request)
    XCTAssertEqual(request.httpShouldUsePipelining, true)
    _ = adapter.httpShouldUsePipelining(false)
    adapter.apply(to: &request)
    XCTAssertEqual(request.httpShouldUsePipelining, false)
  }
}
