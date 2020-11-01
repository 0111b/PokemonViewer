//
//  NetworkCache.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

protocol NetworkCache {
  func get(for request: URLRequestConvertible) -> CachedURLResponse?
  func set(_ response: CachedURLResponse, for request: URLRequestConvertible)
}

final class DisabledNetworkCache: NetworkCache {
  func get(for request: URLRequestConvertible) -> CachedURLResponse? {
    return nil
  }

  func set(_ response: CachedURLResponse, for request: URLRequestConvertible) {
    // nop
  }
}

extension URLCache: NetworkCache {
  func set(_ response: CachedURLResponse, for request: URLRequestConvertible) {
    storeCachedResponse(response, for: request.urlRequest)
  }

  func get(for request: URLRequestConvertible) -> CachedURLResponse? {
    cachedResponse(for: request.urlRequest)
  }
}
