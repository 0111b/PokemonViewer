//
//  PokemonAPIService.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

final class PokemonAPIServiceImp: APIService, PokemonAPIService {

  func list(page: PokemonAPI.Page,
            cachePolicy: RequestCachePolicy,
            completion: @escaping (PokemonAPIService.PockemonsPageResponse) -> Void) -> Disposable {
    return self.obtain(location: .pokemons(page: page),
                       cachePolicy: cachePolicy,
                       completion: completion)
  }
}

private extension HTTPLocation {
  static func pokemons(page: PokemonAPI.Page) -> HTTPLocation {
    HTTPLocation(urlPath: "/api/v2/pokemon",
                 queryItems: [
                  "limit": String(page.limit),
                  "offset": String(page.offset)
                 ]).accept(.json)
  }
}
