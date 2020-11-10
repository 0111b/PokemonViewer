//
//  UITestCase.swift
//  PokemonViewerUITests
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import XCTest
import UITeststingSupport

class UITestCase: XCTestCase {
  var app: XCUIApplication!

  override func setUpWithError() throws {
    app = XCUIApplication()
    app.launchArguments = [AppTestConfiguration.testingFlag]
    continueAfterFailure = false
  }

  func launch(with config: AppTestConfiguration = AppTestConfiguration()) {
    app.launchEnvironment = config.toRawValue()
    app.launch()
  }

  static let waitTimeout: TimeInterval = 3
}
