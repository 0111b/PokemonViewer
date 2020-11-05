//
//  MockNetworkService.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import Foundation
@testable import PokemonViewer

final class MockNetworkService: NetworkService {

  @Mock
  public var fetchResult: NetworkResult<Data>

  public lazy var fetchMock = MockFunc.mock(for: self.fetch(request:cachePolicy:completion:))
  func fetch(request: URLRequestConvertible,
             cachePolicy: RequestCachePolicy,
             completion: @escaping (NetworkResult<Data>) -> Void) -> Cancellable {
    completion(fetchResult)
    return fetchMock.callAndReturn((request, cachePolicy, completion))
  }


}
