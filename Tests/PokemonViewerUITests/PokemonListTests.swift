//
//  PokemonListTests.swift
//  PokemonViewerUITests
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import XCTest
import UITeststingSupport

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

  func testNoNetwork() {
    launch()
    let screen = app.pokemonListScreen
    XCTAssertTrue(screen.statusHint.exists)
  }

  func testShowDetails() {
    launch(with: AppTestConfiguration(pokemonService: PokemonServiceConfig(listConfig: .sampleValue)))
    let screen = app.pokemonListScreen
    _ = screen.openDetails()
  }

  func testNameFilterNoMatch() {
    launch(with: AppTestConfiguration(pokemonService: PokemonServiceConfig(listConfig: .sampleValue)))
    let screen = app.pokemonListScreen
    XCTAssertTrue(screen.pokemon(at: 0).exists)
    XCTAssertTrue(screen.pokemon(at: 1).exists)
    screen.search(name: "Invalid search")
    XCTAssertFalse(screen.pokemon(at: 0).waitForExistence(timeout: UITestCase.waitTimeout))
    XCTAssertFalse(screen.pokemon(at: 1).waitForExistence(timeout: UITestCase.waitTimeout))
    XCTAssertTrue(screen.statusHint.exists)
  }

  func testNameFilterPartialMatch() {
    launch(with: AppTestConfiguration(pokemonService: PokemonServiceConfig(listConfig: .sampleValue)))
    let screen = app.pokemonListScreen
    screen.search(name: "2")
    XCTAssertTrue(screen.pokemon(at: 0).waitForExistence(timeout: UITestCase.waitTimeout))
    XCTAssertFalse(screen.pokemon(at: 1).waitForExistence(timeout: UITestCase.waitTimeout))
  }
}
