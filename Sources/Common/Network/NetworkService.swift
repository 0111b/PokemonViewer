//
//  NetworkService.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation
import os.log

protocol NetworkService {
  func fetch(request: URLRequestConvertible,
             cachePolicy: RequestCachePolicy,
             completion: @escaping (NetworkResult<Data>) -> Void) -> Cancellable
}

final class NetworkServiceImp: NetworkService {

  init(transport: HTTPTransport, cache: NetworkCache) {
    self.transport = transport
    self.cache = cache
  }

  func fetch(request: URLRequestConvertible,
             cachePolicy: RequestCachePolicy,
             completion: @escaping (NetworkResult<Data>) -> Void) -> Cancellable {
    let request = NetworkRequest(request)
    switch cachePolicy {
    case .networkOnly:
      fetchRemote(request: request, completion: completion)
    case .networkFirst:
      fetchRemote(request: request) { [weak self] remoteResult in
        switch remoteResult {
        case .success:
          completion(remoteResult)
        case .failure(let remoteError):
          self?.fetchCached(request: request, completion: { cachedResult in
            let result = cachedResult.mapError { _ in remoteError }
            completion(result)
          })
        }
      }
    case .cacheFirst:
      fetchCached(request: request) { [weak self] result in
        if case .success = result {
          completion(result)
        } else {
          self?.fetchRemote(request: request, completion: completion)
        }
      }
    }
    return request
  }

  private func fetchRemote(request: NetworkRequest, completion: @escaping (NetworkResult<Data>) -> Void) {
    request.singpost(isBegin: true, message: "Fetch")
    request.networkToken = transport.obtain(request: request.urlRequest) { [weak self] fetchResult in
      defer { request.singpost(isBegin: false, message: "Fetch") }
      if case .success(let response) = fetchResult {
        self?.cachingQueue.async {
          let cached = CachedURLResponse(response: response.httpResponse, data: response.data)
          self?.cache.set(cached, for: request.urlRequest)
        }
      }
      guard !request.isCanceled else { return }
      completion(fetchResult.map(\.data))
    }
  }

  private func fetchCached(request: NetworkRequest, completion: @escaping (NetworkResult<Data>) -> Void) {
    request.singpost(isBegin: true, message: "Cached")
    cachingQueue.async { [weak self] in
      defer { request.singpost(isBegin: false, message: "Cached") }
      guard !request.isCanceled else { return }
      guard let data = self?.cache.get(for: request.urlRequest)?.data else {
        completion(.failure(.badRequest))
        return
      }
      completion(.success(data))
    }
  }

  private let transport: HTTPTransport
  private let cache: NetworkCache

  private let cachingQueue = DispatchQueue(label: "com.0111b.PokemonViewer.cachingQueue",
                                           qos: .userInitiated)
}

extension NetworkServiceImp {
  private final class NetworkRequest: Cancellable {
    init(_ request: URLRequestConvertible) {
      urlRequest = request
    }

    let urlRequest: URLRequestConvertible

    func cancel() {
      isCanceled = true
      networkToken?.cancel()
    }

    @Protected
    var networkToken: Cancellable?

    @Protected
    private(set) var isCanceled = false

    func singpost(isBegin: Bool, message: String) {
      if #available(iOS 12.0, *) {
        let signpostId = OSSignpostID(log: Log.networking, object: self as AnyObject)
        os_signpost(isBegin ? .begin : .end,
                    log: Log.networking,
                    name: "Request",
                    signpostID: signpostId,
                    "%@", message)
      }
    }
  }
}
