//
//  MockPokemonAPIService.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import Foundation
@testable import PokemonViewer

final class MockPokemonAPIService: PokemonAPIService {

  @Mock
  public var listResult: NetworkResult<PokemonAPI.PokemonPage>
  public lazy var listMock = MockFunc.mock(for: self.list(page:cachePolicy:completion:))
  func list(page: Page,
            cachePolicy: RequestCachePolicy,
            completion: @escaping (NetworkResult<PokemonAPI.PokemonPage>) -> Void) -> Disposable {
    DispatchQueue.global().async {
      completion(self.listResult)
    }
    return listMock.callAndReturn((page, cachePolicy, completion))
  }

  @Mock
  public var detailsResult: NetworkResult<Pokemon>
  public lazy var detailsMock = MockFunc.mock(for: self.details(for:cachePolicy:completion:))
  func details(for identifier: Identifier<Pokemon>,
               cachePolicy: RequestCachePolicy,
               completion: @escaping (NetworkResult<Pokemon>) -> Void) -> Disposable {
    DispatchQueue.global().async {
      completion(self.detailsResult)
    }
    return detailsMock.callAndReturn((identifier, cachePolicy, completion))
  }

}
