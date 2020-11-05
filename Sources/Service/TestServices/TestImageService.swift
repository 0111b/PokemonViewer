//
//  TestImageService.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import UIKit
import UITeststingSupport

final class TestImageService: ImageService {

  init(config: UITeststingSupport.ImageServiceConfig) {
    self.config = config
  }

  private let config: UITeststingSupport.ImageServiceConfig

  func image(url: URL,
             cachePolicy: RequestCachePolicy,
             adapter: RequestAdapter,
             completion: @escaping (NetworkResult<UIImage>) -> Void) -> Disposable {
    let result: NetworkResult<UIImage>
    switch config {
    case .error:
      result = .failure(.badRequest)
    case .sampleValue:
      result = .success(Images.defaultPlaceholder!)
    }
    DispatchQueue.global().async {
      completion(result)
    }
    return Disposable.empty
  }
}
