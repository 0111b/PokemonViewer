//
//  UITestCase.swift
//  PokemonViewerUITests
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import XCTest

class UITestCase: XCTestCase {
  var app: XCUIApplication!

  override func setUpWithError() throws {
    app = XCUIApplication()
    app.launchArguments = [AppConfiguration.testingFlag]
    continueAfterFailure = false
  }
}
