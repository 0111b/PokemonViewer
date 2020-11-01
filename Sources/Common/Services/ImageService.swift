//
//  ImageService.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import UIKit

protocol ImageService {
  func image(location: HTTPLocation,
             cachePolicy: CachePolicy,
             adapter: RequestAdapter,
             completion: @escaping (NetworkResult<UIImage>) -> Void) -> Disposable
}

final class ImageServiceImp {
  init(requestBuilder: RequestBuilder, network: NetworkService) {
    self.requestBuilder = requestBuilder
    self.network = network
  }

  func image(location: HTTPLocation,
             cachePolicy: CachePolicy = .cacheFirst,
             adapter: RequestAdapter = RequestAdapter(),
             completion: @escaping (NetworkResult<UIImage>) -> Void) -> Disposable {
    guard let request = requestBuilder.request(location, adapter: adapter) else {
      completion(.failure(.badRequest))
      return Disposable.empty
    }
    let token = self.network.fetch(request: request, cachePolicy: .cacheFirst) { [weak self] result in
      switch result {
      case .failure(let error):
        completion(.failure(error))
      case .success(let data):
        self?.imageTransformQueue.async {
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
  private let requestBuilder: RequestBuilder

  private let imageTransformQueue = DispatchQueue(label: "com.0111b.PokemonViewer.imageTransform",
                                                  qos: .userInitiated,
                                                  attributes: .concurrent)
}
