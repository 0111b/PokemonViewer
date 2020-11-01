//
//  NetworkError.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

public enum NetworkError: Error {
  case badRequest
  case invalidStatusCode
  case decodingError(Error)
  case transportError(Error)
}

public typealias NetworkResult<Value> = Swift.Result<Value, NetworkError>
