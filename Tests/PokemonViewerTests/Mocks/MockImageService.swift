//
//  MockImageService.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import UIKit
@testable import PokemonViewer

final class MockImageService: ImageService {

  @Mock
  public var imageResult: NetworkResult<UIImage>
  public lazy var imageMock = MockFunc.mock(for: self.image(url:cachePolicy:adapter:completion:))
  func image(url: URL,
             cachePolicy: RequestCachePolicy,
             adapter: RequestAdapter,
             completion: @escaping (NetworkResult<UIImage>) -> Void) -> Disposable {
    DispatchQueue.global().async {
      completion(self.imageResult)
    }
    return imageMock.callAndReturn((url, cachePolicy, adapter, completion))
  }

}
