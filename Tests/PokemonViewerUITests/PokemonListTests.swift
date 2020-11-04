//
//  PokemonListTests.swift
//  PokemonViewerUITests
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import XCTest

class PokemonListTests: XCTestCase {
  
  var app: XCUIApplication!
  
  
  override func setUpWithError() throws {
    app = XCUIApplication()
    app.launch()
  }
  
  
  func testLayoutSwitch() throws {
    let screen = app.pokemonListScreen
    XCTAssertTrue(screen.exists)
    XCTAssertTrue(screen.listLayoutButton.exists)
    XCTAssertFalse(screen.gridLayoutButton.exists)
    screen.listLayoutButton.tap()
    XCTAssertFalse(screen.listLayoutButton.exists)
    XCTAssertTrue(screen.gridLayoutButton.exists)
    screen.gridLayoutButton.tap()
    XCTAssertTrue(screen.listLayoutButton.exists)
    XCTAssertFalse(screen.gridLayoutButton.exists)
  }
  
}
