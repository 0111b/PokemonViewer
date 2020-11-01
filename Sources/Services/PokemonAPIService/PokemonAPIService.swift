//
//  PokemonAPIService.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

final class PokemonAPIServiceImp: PokemonAPIService {
  init(requestBuilder: RequestBuilder, network: NetworkService) {
    self.requestBuilder = requestBuilder
    self.network = network
  }

  func pokemons(page: PokemonAPI.Page,
                completion: @escaping (PokemonAPIService.PockemonsPageResponse) -> Void) -> Disposable {
    return obtain(location: .pokemons(page: page), completion: completion)
  }

  private func obtain<Object>(location: HTTPLocation,
                              decoder: JSONDecoder = HTTP.defaultDecoder,
                              completion: @escaping (NetworkResult<Object>) -> Void) -> Disposable
  where Object: Decodable {
    guard let request = requestBuilder.request(location) else {
      completion(.failure(.badRequest))
      return Disposable.empty
    }
    let token = self.network.fetch(request: request, cachePolicy: .cacheFirst) { result in
      switch result {
      case .failure(let error): completion(.failure(error))
      case .success(let data):
        do {
          let value = try decoder.decode(Object.self, from: data)
          completion(.success(value))
        } catch let decodingError {
          completion(.failure(.decodingError(decodingError)))
        }
      }
    }
    return Disposable {
      token.cancel()
    }
  }

  private let network: NetworkService
  private let requestBuilder: RequestBuilder

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
