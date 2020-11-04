//
//  TestPokemonAPIService.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import Foundation
import UITeststingSupport

final class TestPokemonAPIService: PokemonAPIService {
  init(config: PokemonServiceConfig) {
    self.config = config
  }

  private let config: PokemonServiceConfig

  func list(page: Page,
            cachePolicy: RequestCachePolicy,
            completion: @escaping (NetworkResult<PokemonAPI.PokemonPage>) -> Void) -> Disposable {
    let result: NetworkResult<PokemonAPI.PokemonPage>
    switch config.listConfig {
    case .error:
      result = .failure(.badRequest)
    case .sampleValue:
      result = .success(self.page(page.pageNumber))
    }
    DispatchQueue.global().async {
      completion(result)
    }
    return Disposable.empty
  }

  func details(for identifier: Identifier<Pokemon>,
               cachePolicy: RequestCachePolicy,
               completion: @escaping (NetworkResult<Pokemon>) -> Void) -> Disposable {
    let result: NetworkResult<Pokemon>
    switch config.detailsConfig {
    case .error:
      result = .failure(.badRequest)
    case .sampleValue:
      result = .success(self.pokemon(identifier))
    }
    DispatchQueue.global().async {
      completion(result)
    }
    return Disposable.empty
  }

  private func page(_ pageNumber: UInt) -> PokemonAPI.PokemonPage {
    PokemonAPI.PokemonPage(count: 100, items: [])
  }

  private func pokemon(_ id: Identifier<Pokemon>) -> Pokemon {
    Pokemon(id: .init(rawValue: "1"), height: 1, weight: 1, sprites: [], stats: [], abilities: [], types: [])
  }
}
