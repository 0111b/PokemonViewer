//
//  Stubs.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import Foundation
@testable import PokemonViewer

public enum Stubs {
  public static func url() -> URL {
    URL(string: "http://google.com")!
  }

  public static func request() -> URLRequestConvertible {
    URLRequest(url: url())
  }

  public static func data() -> Data {
    "Sample data".data(using: .utf8)!
  }

  public static func cachedResponse(data: Data? = nil) -> CachedURLResponse {
    CachedURLResponse(response: httpResponse(statusCode: 200), data: data ?? self.data())
  }

  public static func httpResponse(statusCode: Int, headers: [String: String] = [:]) -> HTTPURLResponse {
    HTTPURLResponse(url: url(), statusCode: statusCode, httpVersion: nil, headerFields: headers)!
  }

  public static func json(from object: Any) throws -> Data {
    try JSONSerialization.data(withJSONObject: object, options: [])
  }
}
