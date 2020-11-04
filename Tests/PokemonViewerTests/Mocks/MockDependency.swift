//
//  MockDependency.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import Foundation
@testable import PokemonViewer

final class MockDependency {

  var mockPokemonAPIService = MockPokemonAPIService()

  var mockImageService = MockImageService()

}

extension MockDependency: PokemonAPIServiceProvider {
  var pokemonAPIService: PokemonAPIService { mockPokemonAPIService }
}

extension MockDependency: ImageServiceProvider {
  var imageService: ImageService { mockImageService }
}
