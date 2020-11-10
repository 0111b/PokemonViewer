//
//  SpriteLegendViewControllerTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 10.11.2020.
//

import XCTest
@testable import PokemonViewer

final class SpriteLegendViewControllerTests: XCTestCase {

  func testDefault() {
    let view = SpriteLegendViewController(viewModel: .init())
    view.assertSnapshot()
  }

}
