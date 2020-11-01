//
//  HTTPTransport.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol URLRequestConvertible {
  var urlRequest: URLRequest { get }
}

public protocol HTTPTransport {
  typealias Response = (data: Data, response: HTTPURLResponse)
  typealias Result = Swift.Result<Response, NetworkError>

  func obtain(request: URLRequestConvertible,
              completion: @escaping (HTTPTransport.Result) -> Void) -> Cancellable
}
