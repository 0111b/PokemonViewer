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

  var exists: Bool { return app.otherElements[Screen.name].waitForExistence(timeout: 1) }

  var navigationBar: XCUIElement { return app.navigationBars.firstMatch }
  var gridLayoutButton: XCUIElement { return navigationBar.buttons[Screen.gridLayoutButton] }
  var listLayoutButton: XCUIElement { return navigationBar.buttons[Screen.listLayoutButton] }
}
