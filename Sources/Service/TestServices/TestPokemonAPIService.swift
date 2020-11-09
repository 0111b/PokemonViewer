//
//  TestPokemonAPIService.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import Foundation
import UITeststingSupport

final class TestPokemonAPIService: PokemonAPIService {
  init(config: UITeststingSupport.PokemonServiceConfig) {
    self.config = config
  }

  private let config: UITeststingSupport.PokemonServiceConfig

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
    let items = stride(from: 0, to: 5, by: 1)
      .map(AccessibilityId.PokemonList.pokemon(at:))
      .map(Identifier<Pokemon>.init(rawValue:))
    return PokemonAPI.PokemonPage(count: 100,
                                  items: items)
  }

  private func pokemon(_ id: Identifier<Pokemon>) -> Pokemon {
    Pokemon(id: id, height: 1, weight: 1, sprites: [sprite()], stats: [], abilities: [], types: [])
  }

  private func sprite() -> PokemonSprite {
    PokemonSprite(url: URL(string: "https://google.com")!, kind: .frontShiny)
  }
}
