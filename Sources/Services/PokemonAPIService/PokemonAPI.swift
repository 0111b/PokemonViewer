//
//  PokemonAPI.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

protocol PokemonAPIServiceProvider {
  var pokemonAPIService: PokemonAPIService { get }
}

protocol PokemonAPIService {
  typealias PockemonsPageResponse = NetworkResult<PokemonAPI.PageResponse<PokemonAPI.PokemonName>>
  func pokemons(page: PokemonAPI.Page,
                cachePolicy: CachePolicy,
                completion: @escaping (PokemonAPIService.PockemonsPageResponse) -> Void) -> Disposable
}

enum PokemonAPI {

  struct Page {
    let offset: Int
    let limit: Int

    init(limit: Int) {
      offset = 0
      self.limit = limit
    }

    func next() -> Page {
      Page(offset: offset + limit, limit: limit)
    }

    private init(offset: Int, limit: Int) {
      self.offset = offset
      self.limit = limit
    }
  }

  struct PokemonName: Decodable, Hashable {
    let name: String
  }

  struct PageResponse<Value: Decodable>: Decodable {
    let count: Int
    let results: [Value]
  }
}
