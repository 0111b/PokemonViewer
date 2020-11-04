//
//  APIService.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

class APIService {
  init(requestBuilder: RequestBuilder, network: NetworkService) {
    self.requestBuilder = requestBuilder
    self.network = network
  }

  func obtain<Object>(location: HTTPLocation,
                      cachePolicy: RequestCachePolicy = .networkFirst,
                      adapter: RequestAdapter = RequestAdapter(),
                      decoder: JSONDecoder = HTTP.defaultDecoder,
                      completion: @escaping (NetworkResult<Object>) -> Void) -> Disposable
  where Object: Decodable {

    func decode<Object>(_ data: Data,
                        decoder: JSONDecoder,
                        completion: @escaping (NetworkResult<Object>) -> Void) where Object: Decodable {
      decodingQueue.async {
        do {
          let value = try decoder.decode(Object.self, from: data)
          completion(.success(value))
        } catch let decodingError {
          completion(.failure(.decodingError(decodingError)))
        }
      }
    }

    guard let request = requestBuilder.request(location, adapter: adapter) else {
      completion(.failure(.badRequest))
      return Disposable.empty
    }
    let token = self.network.fetch(request: request, cachePolicy: cachePolicy) { result in
      switch result {
      case .failure(let error):
        completion(.failure(error))
      case .success(let data):
        decode(data, decoder: decoder, completion: completion)
      }
    }
    return Disposable {
      token.cancel()
    }
  }

  private let network: NetworkService
  private let requestBuilder: RequestBuilder

  private let decodingQueue = DispatchQueue(label: "com.0111b.PokemonViewer.decodingQueue",
                                            qos: .userInitiated,
                                            attributes: .concurrent)
}
