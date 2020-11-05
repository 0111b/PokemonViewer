//
//  APIServiceTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import XCTest
@testable import PokemonViewer

final class APIServiceTests: XCTestCase {

  var apiService: APIService!
  var networkService: MockNetworkService!
  let requestBuilder = RequestBuilder(baseURL: "https://google.com")
  let location = HTTPLocation(urlPath: "/")

  override func setUpWithError() throws {
    networkService = MockNetworkService()
    apiService = APIService(requestBuilder: requestBuilder, network: networkService)
    networkService.fetchMock.returns(EmptyCancellable())
  }

  func testNetworkError() {
    networkService.$fetchResult.thenReturns(.failure(.badRequest))

    _ = apiService.obtain(location: location) { (result: Result<TestObject, NetworkError>) in
      guard case .failure(.badRequest) = result else {
        XCTFail("Failure expected")
        return
      }
    }
  }

  func testDecodingSuccess() throws {
    let object = TestObject.instance()
    let data = try JSONEncoder().encode(object)
    networkService.$fetchResult.thenReturns(.success(data))

    _ = apiService.obtain(location: location) { (result: Result<TestObject, NetworkError>) in
      guard case .success(let decodedObject) = result else {
        XCTFail("Success expected")
        return
      }
      XCTAssertEqual(object, decodedObject)
    }
  }

  func testDecodingFailure() throws {
    networkService.$fetchResult.thenReturns(.success(Stubs.data()))

    _ = apiService.obtain(location: location) { (result: Result<TestObject, NetworkError>) in
      guard case .failure(.decodingError) = result else {
        XCTFail("Failure expected")
        return
      }
    }
  }
}

private class TestObject: Equatable, Codable {

  init(_ value: String) {
    self.value = value
  }

  let value: String

  static func == (lhs: TestObject, rhs: TestObject) -> Bool {
    lhs.value == rhs.value
  }

  static func instance() -> TestObject {
    TestObject(Stubs.string())
  }
}
