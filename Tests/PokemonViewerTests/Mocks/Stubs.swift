//
//  Stubs.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import Foundation
import XCTest
@testable import PokemonViewer

public enum Stubs {
  public static func url() -> URL {
    URL(string: "http://google.com")!
  }

  public static func request() -> URLRequestConvertible {
    URLRequest(url: url())
  }

  public static func string() -> String {
    "Sample data"
  }

  public static func data() -> Data {
    string().data(using: .utf8)!
  }

  public static func cachedResponse(data: Data? = nil) -> CachedURLResponse {
    CachedURLResponse(response: httpResponse(statusCode: 200), data: data ?? self.data())
  }

  public static func httpResponse(statusCode: Int, headers: [String: String] = [:]) -> HTTPURLResponse {
    HTTPURLResponse(url: url(), statusCode: statusCode, httpVersion: nil, headerFields: headers)!
  }

  public static func load(json: String) throws -> Data {
    try load(resource: json, ofType: "json")
  }

  public static func load(resource: String, ofType type: String?) throws -> Data {
    guard let path = Bundle(for: BundleToken.self).path(forResource: resource, ofType: type) else {
      XCTFail("Resource not found: \(resource) type: \(type ?? String())")
      return Data()
    }
    return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
  }

  public static func pokemon(id: String = "123", sprites: [PokemonSprite], types: [PokemonType] = []) -> Pokemon {
    Pokemon(id: .init(rawValue: id),
            height: 1,
            weight: 1,
            sprites: sprites,
            stats: [],
            abilities: [],
            types: types)
  }

  public static func sprite() -> PokemonSprite {
    PokemonSprite(url: Stubs.url(), kind: .frontDefault)
  }

  static let assertInterval: TimeInterval = 3

}

private final class BundleToken {}
