//
//  NetworkOperation.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

final class NetworkOperation: AsyncOperation {

  init(transport: HTTPTransport, request: URLRequestConvertible) {
    self.transport = transport
    self.request = request
  }

  let transport: HTTPTransport
  let request: URLRequestConvertible
  var result: HTTPTransport.Result?
  private var cancelationToken: Cancellable?

  override func run() {
    cancelationToken = transport.obtain(request: request, completion: { [weak self] result in
      guard let self = self else { return }
      defer { self.state = .finished }
      guard !self.isCancelled else { return }
      self.result = result
    })
  }

  override func cancel() {
    super.cancel()
    result = .failure(.canceled)
    cancelationToken?.cancel()
    state = .finished
  }
}
