//
//  URLSession+HTTPtransport.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

extension URLRequest: URLRequestConvertible {
  public var urlRequest: URLRequest { return self }
}

extension  URLSessionTask: Cancellable {}

extension URLSession: HTTPTransport {

  public func obtain(request: URLRequestConvertible,
                     completion: @escaping (HTTPTransport.Result) -> Void) -> Cancellable {
    let task = dataTask(with: request.urlRequest) { data, response, error in
      let result: HTTPTransport.Result
      if let error = error {
        result = .failure(.transportError(error))
      } else if let data = data,
                let response = response as? HTTPURLResponse,
                200..<300 ~= response.statusCode {
        result = .success((data, response))
      } else {
        result = .failure(.invalidStatusCode)
      }
      completion(result)
    }
    task.resume()
    return task
  }
}
