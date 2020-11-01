//
//  NetworkService.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

final class NetworkService {
  enum CachePolicy {
    case cacheFirst
    case networkFirst
  }

  init(transport: HTTPTransport, cache: NetworkCache) {
    self.transport = transport
    self.cache = cache
  }

  //swiftlint:disable:next function_body_length
  func fetch(request: URLRequestConvertible,
             cachePolicy: CachePolicy,
             completion: @escaping (NetworkResult<Data>) -> Void) -> Cancellable {
    let fetchCached = FetchCacheOpetation(cache: cache, request: request)
    let fetch = NetworkOperation(transport: transport, request: request)
    let storeInCache = cacheResults(operation: fetch)
    var didFetchCached: Operation!
    var didFetchFromNetwork: Operation!
    let scheduleCacheRequest = BlockOperation { [processingQueue, cachingQueue] in
      didFetchCached.addDependency(fetchCached)
      processingQueue.addOperation(didFetchCached)
      cachingQueue.addOperation(fetchCached)
    }
    let scheduleNetworkRequest = BlockOperation { [processingQueue, cachingQueue] in
      storeInCache.addDependency(fetch)
      didFetchFromNetwork.addDependency(fetch)
      processingQueue.addOperation(didFetchFromNetwork)
      cachingQueue.addOperation(storeInCache)
      processingQueue.addOperation(fetch)
    }
    didFetchCached = BlockOperation { [processingQueue, unowned fetchCached, unowned scheduleNetworkRequest] in
      if let data = fetchCached.data {
        completion(.success(data))
        return
      }
      switch cachePolicy {
      case .networkFirst: //network already executed
        let result: NetworkResult<Data> = fetch.result?.map(\.data) ?? .failure(.canceled)
        completion(result)
      case .cacheFirst: // schedule network
        processingQueue.addOperation(scheduleNetworkRequest)
      }
    }
    didFetchFromNetwork = BlockOperation { [processingQueue, unowned fetch, unowned scheduleCacheRequest] in
      guard let fetchResult = fetch.result?.map(\.data) else {
        completion(.failure(.canceled))
        return
      }
      if case .success(let data) = fetchResult {
        completion(.success(data))
        return
      }
      switch cachePolicy {
      case .networkFirst: // schedule cache
        processingQueue.addOperation(scheduleCacheRequest)
      case .cacheFirst: // cache already executed
        let result: NetworkResult<Data> = fetchCached.data.map { .success($0) } ?? fetchResult
        completion(result)
      }
    }
    switch cachePolicy {
    case .networkFirst:
      processingQueue.addOperation(scheduleNetworkRequest)
    case .cacheFirst:
      processingQueue.addOperation(scheduleCacheRequest)
    }
    return OperationContainer(operations: [
      fetchCached, didFetchCached,
      fetch, storeInCache, didFetchFromNetwork,
      scheduleCacheRequest, scheduleNetworkRequest
    ])
  }

  private func cacheResults(operation: NetworkOperation) -> Operation {
    BlockOperation { [cache] in
      guard case .success(let response)? = operation.result else { return }
      let cached = CachedURLResponse(response: response.httpResponse, data: response.data)
      cache.set(cached, for: operation.request)
    }
  }

  private let transport: HTTPTransport
  private let cache: NetworkCache
  private let cachingQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    queue.qualityOfService = .userInitiated
    return queue
  }()
  private let processingQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 4
    queue.qualityOfService = .userInitiated
    return queue
  }()
}
