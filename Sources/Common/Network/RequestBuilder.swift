//
//  RequestBuilder.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class RequestBuilder {

  public init(baseURL: String) {
    self.baseURL = baseURL
  }

  let baseURL: String

  public func request(_ location: @autoclosure () -> HTTPLocation,
                      adapter: RequestAdapter = RequestAdapter()) -> URLRequest? {
    guard var components = URLComponents(string: baseURL) else { return nil }
    let location = location()
    components.path = location.urlPath
    components.queryItems = location.queryItems
      .map(URLQueryItem.init(name:value:))
    guard let url = components.url else { return nil }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = location.method.rawValue
    urlRequest.httpBody = location.body.data
    urlRequest.allHTTPHeaderFields = location.httpHeaders
    adapter.apply(to: &urlRequest)
    return urlRequest
  }
}
