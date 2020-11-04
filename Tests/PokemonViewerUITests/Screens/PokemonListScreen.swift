//
//  PokemonListScreen.swift
//  PokemonViewerUITests
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import XCTest

extension XCUIApplication {
  var pokemonListScreen: PokemonListScreen { return PokemonListScreen(app: self) }
}


struct PokemonListScreen {
  let app: XCUIApplication

  var exists: Bool { return app.otherElements["PokemonListScreen"].waitForExistence(timeout: 1) }

  var navigationBar: XCUIElement { return app.navigationBars.firstMatch }
  var gridLayoutButton: XCUIElement { return navigationBar.buttons["gridLayoutButton"] }
  var listLayoutButton: XCUIElement { return navigationBar.buttons["listLayoutButton"] }
}
