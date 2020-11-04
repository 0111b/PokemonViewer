//
//  AppLaunchTests.swift
//  PokemonViewerUITests
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import XCTest

class AppLaunchTests: XCTestCase {

  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }

}
