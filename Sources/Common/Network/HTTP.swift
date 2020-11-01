//
//  HTTP.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

public enum HTTP {

  public static var defaultDecoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }

  /// HTTP method definitions.
  ///
  /// See [spec](https://tools.ietf.org/html/rfc7231#section-4.3)
  public enum Method: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
  }

  public typealias QueryItems = [String: String]
  public typealias Headers = [String: String]

  public enum Body {
    case empty

    public var data: Data? {
      switch self {
      case .empty: return nil
      }
    }
  }
}
