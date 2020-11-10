//
//  TitledValueViewTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 10.11.2020.
//

import XCTest
@testable import PokemonViewer

final class TitledValueViewTests: XCTestCase {

  func testDefault() {
    let view = TitledValueView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    view.set(title: "Title", value: "Value")
    view.assertSnapshot()
  }

  func testStyle() {
    let view = TitledValueView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    view.set(title: "Title", value: "Value")
    view.apply(style: .init(titleColor: .red,
                            titleFont: UIFont.preferredFont(forTextStyle: .caption1),
                            valueColor: .blue,
                            valueFont: UIFont.preferredFont(forTextStyle: .title2)))
    view.assertSnapshot()
  }

}
