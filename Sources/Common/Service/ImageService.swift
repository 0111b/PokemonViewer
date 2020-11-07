//
//  ImageService.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import UIKit

protocol ImageServiceProvider {
  var imageService: ImageService { get }
}

protocol ImageService {
  func image(url: URL,
             cachePolicy: RequestCachePolicy,
             adapter: RequestAdapter,
             completion: @escaping (NetworkResult<UIImage>) -> Void) -> Disposable
}

final class ImageServiceImp: ImageService {
  init(network: NetworkService) {
    self.network = network
  }

  func image(url: URL,
             cachePolicy: RequestCachePolicy = .cacheFirst,
             adapter: RequestAdapter = RequestAdapter(),
             completion: @escaping (NetworkResult<UIImage>) -> Void) -> Disposable {
    let request = URLRequest(url: url)
    let processingQueue = imageTransformQueue
    let token = self.network.fetch(request: request, cachePolicy: cachePolicy) { result in
      switch result {
      case .failure(let error):
        completion(.failure(error))
      case .success(let data):
        processingQueue.async {
          if let image = UIImage(data: data) {
            completion(.success(image))
          } else {
            completion(.failure(.decodingError(nil)))
          }
        }
      }
    }
    return Disposable {
      token.cancel()
    }
  }

  private let network: NetworkService

  private let imageTransformQueue = DispatchQueue(label: "com.0111b.PokemonViewer.imageTransform",
                                                  qos: .userInitiated,
                                                  attributes: .concurrent)
}
