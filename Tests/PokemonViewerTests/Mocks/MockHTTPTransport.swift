//
//  MockHTTPTransport.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import Foundation
@testable import PokemonViewer

public class MockHTTPTransport: HTTPTransport {
  public init() {}

  public func thenObtain(data: Data) {
    self.$obtainResult.thenReturns(.success((data, Stubs.httpResponse(statusCode: 200))))
  }

  public func thenObtain(error: NetworkError) {
    self.$obtainResult.thenReturns(.failure(error))
  }

  @Mock
  public var obtainResult: HTTPTransport.Result
  public lazy var obtainMock = MockFunc.mock(for: self.obtain(request:completion:))

  public func obtain(request: URLRequestConvertible,
                     completion: @escaping (HTTPTransport.Result) -> Void) -> Cancellable {
    completion(obtainResult)
    return obtainMock.callAndReturn((request, completion))
  }
}
