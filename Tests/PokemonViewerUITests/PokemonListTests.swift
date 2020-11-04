//
//  PokemonListTests.swift
//  PokemonViewerUITests
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import XCTest

final class PokemonListTests: UITestCase {

  func testLayoutSwitch() throws {
    launch()
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
