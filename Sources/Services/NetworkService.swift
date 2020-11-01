//
//  NetworkService.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

public final class NetworkService {

  public init(baseURL: String,
              transport: HTTPTransport = URLSession.shared) {
    self.baseURL = baseURL
    self.transport = transport
  }

  let baseURL: String
  let transport: HTTPTransport

  public func request(_ location: @autoclosure () -> HTTPLocation,
                      adapter: RequestAdapter = RequestAdapter(),
                      completion: @escaping (HTTPTransport.Result) -> Void) -> Cancellable {
    let invalidRequest: () -> Cancellable = {
      completion(.failure(.badRequest))
      return AnyCancellable.empty
    }

    guard var components = URLComponents(string: baseURL) else {
      return invalidRequest()
    }
    let location = location()
    components.path = location.urlPath
    components.queryItems = location.queryItems
      .map(URLQueryItem.init(name:value:))
    guard let url = components.url else { return invalidRequest() }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = location.method.rawValue
    urlRequest.httpBody = location.body.data
    urlRequest.allHTTPHeaderFields = location.httpHeaders
    adapter.apply(to: &urlRequest)
    return transport.obtain(request: urlRequest, completion: completion)

  }
}
