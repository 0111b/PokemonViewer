//
//  PokemonDetailsHeaderViewTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 10.11.2020.
//

import XCTest
@testable import PokemonViewer

final class PokemonDetailsHeaderViewTests: XCTestCase {
  func testTitle() {
    let view = PokemonDetailsHeaderView(title: "Title")
    view.assertSnapshot()
  }

  func testRightView() {
    let rightView = UIView()
    rightView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    rightView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    rightView.backgroundColor = .red
    let view = PokemonDetailsHeaderView(title: "Title", rightView: rightView)
    view.assertSnapshot()
  }
}
