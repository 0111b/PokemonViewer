//
//  HTTPLocationTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import XCTest
@testable import PokemonViewer

final class HTTPLocationTests: XCTestCase {

  var location: HTTPLocation!

  override func setUpWithError() throws {
    location = HTTPLocation(urlPath: "/")
  }

  func testAccept() {
    _ = location.accept(.json)
    XCTAssertEqual(location.httpHeaders["Accept"], "application/json")
  }

  func testContentType() {
    _ = location.contenType(.json)
    XCTAssertEqual(location.httpHeaders["Content-Type"], "application/json")
  }

}
