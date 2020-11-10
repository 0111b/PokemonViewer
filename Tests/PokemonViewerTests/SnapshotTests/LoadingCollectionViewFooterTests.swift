//
//  LoadingCollectionViewFooterTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 10.11.2020.
//

import XCTest
@testable import PokemonViewer

final class LoadingCollectionViewFooterTests: XCTestCase {

  func testClear() {
    let view = LoadingCollectionViewFooter(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    view.update(with: .clear)
    view.assertSnapshot()
  }

  func testLoading() {
    let view = LoadingCollectionViewFooter(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    view.update(with: .loading)
    view.assertSnapshot()
  }

  func testHint() {
    let view = LoadingCollectionViewFooter(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    view.update(with: .hint("Hint"))
    view.assertSnapshot()
  }

}
