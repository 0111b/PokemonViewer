//
//  PokemonDetailsTests.swift
//  PokemonViewerUITests
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import XCTest
import UITeststingSupport

final class PokemonDetailsTests: UITestCase {

  func testNoNetwork() {
    launch(with: AppTestConfiguration(pokemonService: PokemonServiceConfig(listConfig: .sampleValue)))
    let screen = app.pokemonListScreen.openDetails()
    XCTAssertTrue(screen.errorView.exists)
  }

  func testNameShown() {
    launch(with: AppTestConfiguration(pokemonService: PokemonServiceConfig(listConfig: .sampleValue,
                                                                           detailsConfig: .sampleValue)))
    let screen = app.pokemonListScreen.openDetails()
    XCTAssertTrue(screen.contentView.exists)
  }

  func testShowLegend() {
    launch(with: AppTestConfiguration(pokemonService: PokemonServiceConfig(listConfig: .sampleValue,
                                                                           detailsConfig: .sampleValue)))
    _ = app.pokemonListScreen
      .openDetails()
      .showLegend()
  }
}
