//
//  PokemonListScreen.swift
//  PokemonViewerUITests
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import XCTest
import UITeststingSupport

extension XCUIApplication {
  var pokemonListScreen: PokemonListScreen { return PokemonListScreen(app: self) }
}


struct PokemonListScreen {
  let app: XCUIApplication

  typealias Screen = AccessibilityId.PokemonList

  var exists: Bool { app.otherElements[Screen.screen].waitForExistence(timeout: UITestCase.waitTimeout) }

  var navigationBar: XCUIElement { app.navigationBars.firstMatch }
  var gridLayoutButton: XCUIElement { navigationBar.buttons[Screen.gridLayoutButton] }
  var listLayoutButton: XCUIElement { navigationBar.buttons[Screen.listLayoutButton] }
  var pokemonList: XCUIElement { app.collectionViews[Screen.pokemonList] }
  var statusView: XCUIElement { pokemonList.otherElements[Screen.statusView] }
  var statusHint: XCUIElement { pokemonList.staticTexts[Screen.statusHint] }
  var pokemonFilter: XCUIElement { navigationBar.searchFields.firstMatch }
  func pokemon(at index: Int) -> XCUIElement { pokemonList.cells[Screen.pokemon(at: index)] }

  func openDetails(at index: Int = 1) -> PokemonDetailsScreen {
    XCTAssertTrue(self.exists)
    pokemon(at: index).tap()
    let screen = app.pokemonDetailsScreen
    XCTAssertTrue(screen.exists)
    return screen
  }

  func search(name: String) {
    pokemonFilter.tap()
    pokemonFilter.typeText(name)
  }
}
