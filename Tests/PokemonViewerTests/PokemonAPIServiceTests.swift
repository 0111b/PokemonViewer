//
//  PokemonAPIServiceTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import XCTest
@testable import PokemonViewer

final class PokemonAPIServiceTests: XCTestCase {

  var apiService: PokemonAPIService!
  var networkService: MockNetworkService!
  let requestBuilder = RequestBuilder(baseURL: "https://google.com")
  let location = HTTPLocation(urlPath: "/")


  override func setUpWithError() throws {
    networkService = MockNetworkService()
    apiService = PokemonAPIServiceImp(requestBuilder: requestBuilder, network: networkService)
    networkService.fetchMock.returns(EmptyCancellable())
  }

  func assertSuccess<Object>() -> (NetworkResult<Object>) -> Void { { result in
    guard case .success = result else {
      XCTFail("Success expected")
      return
    }
  }}

  func testListDecoding() throws {
    let data = try Stubs.load(json: "PokemonList")
    networkService.$fetchResult.thenReturns(.success(data))

    _ = apiService.list(page: Page(limit: 10), cachePolicy: .networkOnly, completion: assertSuccess())
  }

  func testListRequest() {
    networkService.$fetchResult.thenReturns(.failure(.invalidStatusCode))
    let page = Page(limit: 42).next().next()

    _ = apiService.list(page: page, cachePolicy: .networkOnly, completion: { _ in })

    let (request, _, _) = networkService.fetchMock.input
    request.assert(path: "/api/v2/pokemon")
    request.assert(query: [
      URLQueryItem(name: "offset", value: "84"),
      URLQueryItem(name: "limit", value: "42")
    ])
  }


  func testDetailsDecoding() throws {
    let data = try Stubs.load(json: "PokemonDetail")
    let pokemon = Identifier<Pokemon>(rawValue: "123")
    networkService.$fetchResult.thenReturns(.success(data))

    _ = apiService.details(for: pokemon, cachePolicy: .networkOnly, completion: assertSuccess())
  }

  func testDetailsRequest() {
    networkService.$fetchResult.thenReturns(.failure(.invalidStatusCode))
    let string = Stubs.string()
    let pokemon = Identifier<Pokemon>(rawValue: string)

    _ = apiService.details(for: pokemon, cachePolicy: .networkOnly, completion: { _ in })

    let (request, _, _) = networkService.fetchMock.input
    request.assert(path: "/api/v2/pokemon/\(string)")
  }
}

extension URLRequestConvertible {
  func assert(path: String) {
    XCTAssertEqual(path, urlRequest.url?.path)
  }

  func assert(query: [URLQueryItem]) {
    guard let url = urlRequest.url,
          let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
          let queryItems = components.queryItems
    else {
      XCTFail("Invalid url")
      return
    }
    XCTAssertEqual(Set(query), Set(queryItems))
  }
}
