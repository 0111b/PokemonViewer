//
//  SpriteLegendScreen.swift
//  PokemonViewerUITests
//
//  Created by Alexandr Goncharov on 09.11.2020.
//

import XCTest
import UITeststingSupport

extension XCUIApplication {
  var spriteLegendScreen: SpriteLegendScreen { return SpriteLegendScreen(app: self) }
}


struct SpriteLegendScreen {

  let app: XCUIApplication

  typealias Screen = AccessibilityId.SpriteLegend

  var exists: Bool { app.otherElements[Screen.screen].waitForExistence(timeout: UITestCase.waitTimeout) }

}
