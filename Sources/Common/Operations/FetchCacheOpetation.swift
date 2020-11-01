//
//  FetchCacheOpetation.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

final class FetchCacheOpetation: AsyncOperation {
  init(cache: NetworkCache, request: URLRequestConvertible) {
    self.cache = cache
    self.request = request
  }

  let cache: NetworkCache
  let request: URLRequestConvertible
  var data: Data?

  override func run() {
    defer { self.state = .finished }
    guard !isCancelled else { return }
    data = cache.get(for: request.urlRequest)?.data
  }
}
