//
//  MockNetworkCache.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import Foundation
@testable import PokemonViewer

final class MockNetworkCache: NetworkCache {

  public lazy var getMock = MockFunc.mock(for: self.get(for:))
  func get(for request: URLRequestConvertible) -> CachedURLResponse? {
    getMock.callAndReturn(request)
  }

  public lazy var setMock = MockFunc<(CachedURLResponse, URLRequestConvertible), Void>()
  func set(_ response: CachedURLResponse, for request: URLRequestConvertible) {
    setMock.call(with: (response, request))
  }

}
