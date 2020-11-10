//
//  EmptyPokemonDetailsViewControllerTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 10.11.2020.
//

import XCTest
@testable import PokemonViewer

final class EmptyPokemonDetailsViewControllerTests: XCTestCase {

  func testDefault() {
    let view = EmptyPokemonDetailsViewController(viewModel: .init(hint: .noItemSelected))
    view.assertSnapshot()
  }

}
