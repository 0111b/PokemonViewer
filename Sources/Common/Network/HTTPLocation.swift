//
//  HTTPLocation.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

public final class HTTPLocation {
  var urlPath: String
  var method: HTTP.Method
  var queryItems: HTTP.QueryItems
  var body: HTTP.Body
  var httpHeaders: HTTP.Headers

  public init(urlPath: String,
              method: HTTP.Method = .get,
              queryItems: HTTP.QueryItems = [:],
              body: HTTP.Body = .empty,
              httpHeaders: HTTP.Headers? = nil) {
    self.urlPath = urlPath
    self.method = method
    self.queryItems = queryItems
    self.body = body
    self.httpHeaders = httpHeaders ?? [:]
  }

  public func accept(_ contentType: ContentType) -> Self {
    httpHeaders["Accept"] = contentType.rawValue
    return self
  }

  public func contenType(_ contentType: ContentType) -> Self {
    httpHeaders["Content-Type"] = contentType.rawValue
    return self
  }

  public enum ContentType: String {
    case json = "application/json"
  }
}
