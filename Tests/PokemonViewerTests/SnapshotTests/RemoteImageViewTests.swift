//
//  RemoteImageViewTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 10.11.2020.
//

import XCTest
@testable import PokemonViewer

final class RemoteImageViewTests: XCTestCase {
  func testLoading() {
    let view = RemoteImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    view.tintColor = Colors.accent
    view.set(state: .loading)
    view.assertSnapshot()
  }

  func testImage() {
    let view = RemoteImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    view.tintColor = Colors.accent
    view.set(state: .image(Images.defaultPlaceholder))
    view.assertSnapshot()
  }
}
