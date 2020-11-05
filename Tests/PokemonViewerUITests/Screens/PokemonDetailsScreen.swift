//
//  PokemonDetailsScreen.swift
//  UITeststingSupport
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import XCTest
import UITeststingSupport

extension XCUIApplication {
  var pokemonDetailsScreen: PokemonDetailsScreen { return PokemonDetailsScreen(app: self) }
}


struct PokemonDetailsScreen {
  let app: XCUIApplication

  typealias Screen = AccessibilityId.PokemonDetails

  var exists: Bool { app.otherElements[Screen.screen].waitForExistence(timeout: 1) }

  var errorView: XCUIElement { app.otherElements[Screen.errorView] }
  var contentView: XCUIElement { app.otherElements[Screen.contentView] }
  var pokemonName: XCUIElement { contentView.staticTexts[Screen.pokemonName] }
}
