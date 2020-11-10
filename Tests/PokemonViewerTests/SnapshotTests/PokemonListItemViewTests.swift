//
//  PokemonListItemViewTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 10.11.2020.
//

import XCTest
@testable import PokemonViewer

final class PokemonListItemViewTests: XCTestCase {
  func testClear() {
    let view = PokemonListItemView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    view.apply(style: .init(titleColor: .red,
                            titleFont: Fonts.title,
                            backgroundColor: .blue))
    view.resetToEmptyState()
    view.assertSnapshot()
  }

  func testGridNoImage() {
    let view = PokemonListItemView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    view.apply(style: .init(titleColor: .red,
                            titleFont: Fonts.title,
                            backgroundColor: .blue))
    let state = PokemonListItemViewState(title: NSAttributedString(string: "Title"),
                                         typeColors: [.blue, .orange],
                                         hasNoImage: true,
                                         image: .image(nil))
    let observable = Observable(value: state)
    view.set(state: observable, layout: .grid, uiQueue: nil)
    sleep(UInt32(Stubs.assertInterval))
    view.assertSnapshot()
  }

  func testGridImage() {
    let view = PokemonListItemView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    view.apply(style: .init(titleColor: .red,
                            titleFont: Fonts.title,
                            backgroundColor: .blue))
    let state = PokemonListItemViewState(title: NSAttributedString(string: "Title"),
                                         typeColors: [.blue, .orange],
                                         hasNoImage: false,
                                         image: .image(Images.defaultPlaceholder))
    let observable = Observable(value: state)
    view.set(state: observable, layout: .grid, uiQueue: nil)
    sleep(UInt32(Stubs.assertInterval))
    view.assertSnapshot()
  }

  func testGridLoading() {
    let view = PokemonListItemView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    view.apply(style: .init(titleColor: .red,
                            titleFont: Fonts.title,
                            backgroundColor: .blue))
    let state = PokemonListItemViewState(title: NSAttributedString(string: "Title"),
                                         typeColors: [.blue, .orange],
                                         hasNoImage: false,
                                         image: .loading)
    let observable = Observable(value: state)
    view.set(state: observable, layout: .grid, uiQueue: nil)
    sleep(UInt32(Stubs.assertInterval))
    view.assertSnapshot()
  }

  func testListNoImage() {
    let view = PokemonListItemView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    view.apply(style: .init(titleColor: .red,
                            titleFont: Fonts.title,
                            backgroundColor: .blue))
    let state = PokemonListItemViewState(title: NSAttributedString(string: "Title"),
                                         typeColors: [.blue, .orange],
                                         hasNoImage: true,
                                         image: .image(nil))
    let observable = Observable(value: state)
    view.set(state: observable, layout: .list, uiQueue: nil)
    sleep(UInt32(Stubs.assertInterval))
    view.assertSnapshot()
  }

  func testListImage() {
    let view = PokemonListItemView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    view.apply(style: .init(titleColor: .red,
                            titleFont: Fonts.title,
                            backgroundColor: .blue))
    let state = PokemonListItemViewState(title: NSAttributedString(string: "Title"),
                                         typeColors: [.blue, .orange],
                                         hasNoImage: false,
                                         image: .image(Images.defaultPlaceholder))
    let observable = Observable(value: state)
    view.set(state: observable, layout: .list, uiQueue: nil)
    sleep(UInt32(Stubs.assertInterval))
    view.assertSnapshot()
  }

  func testListLoading() {
    let view = PokemonListItemView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    view.apply(style: .init(titleColor: .red,
                            titleFont: Fonts.title,
                            backgroundColor: .blue))
    let state = PokemonListItemViewState(title: NSAttributedString(string: "Title"),
                                         typeColors: [.blue, .orange],
                                         hasNoImage: false,
                                         image: .loading)
    let observable = Observable(value: state)
    view.set(state: observable, layout: .list, uiQueue: nil)
    sleep(UInt32(Stubs.assertInterval))
    view.assertSnapshot()
  }
}
