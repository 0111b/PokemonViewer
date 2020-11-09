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

  var exists: Bool { app.otherElements[Screen.screen].waitForExistence(timeout: UITestCase.waitTimeout) }

  var errorView: XCUIElement { app.otherElements[Screen.errorView] }
  var contentView: XCUIElement { app.otherElements[Screen.contentView] }
  var spriteLegendButton: XCUIElement { contentView.buttons[Screen.spriteLegendButton] }

  func showLegend() -> SpriteLegendScreen {
    XCTAssertTrue(self.exists)
    spriteLegendButton.tap()
    let screen = app.spriteLegendScreen
    XCTAssertTrue(screen.exists)
    return screen
  }
}
