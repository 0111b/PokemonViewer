//
//  PokemonDetailErrorViewTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 10.11.2020.
//

import XCTest
@testable import PokemonViewer

final class PokemonDetailErrorViewTests: XCTestCase {
  func testDefault() {
    let view = PokemonDetailErrorView()
    view.heightAnchor.constraint(equalToConstant: 320).isActive = true
    view.widthAnchor.constraint(equalToConstant: 400).isActive = true
    view.isHidden = false
    view.assertSnapshot()
  }
}
