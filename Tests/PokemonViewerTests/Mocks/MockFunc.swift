//
//  MockFunc.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import Foundation

public struct MockFunc<Input, Output> {
  public var parameters: [Input] = []
  public var result: (Input) -> Output = { _ in fatalError(#function) }

  public init() {}

  public init(result: @escaping (Input) -> Output) {
    self.result = result
  }

  public var count: Int {
    return parameters.count
  }

  public var called: Bool {
    return !parameters.isEmpty
  }

  public var output: Output {
    return result(input)
  }

  public var input: Input {
    return parameters[count - 1]
  }

  public static func mock(for function: (Input) -> Output) -> MockFunc {
    return MockFunc()
  }

  public mutating func call(with input: Input) {
    parameters.append(input)
  }

  public mutating func callAndReturn(_ input: Input) -> Output {
    call(with: input)
    return output
  }
}

// MARK: Syntactic Sugar

extension MockFunc {
  public mutating func returns(_ value: Output) {
    result = { _ in value }
  }

  public mutating func returnsNil<T>()
  where Output == T? {

    result = { _ in nil }
  }

  public mutating func succeeds<T, Error>(_ value: T)
  where Output == Result<T, Error> {

    result = { _ in .success(value) }
  }

  public mutating func fails<T, Error>(_ error: Error)
  where Output == Result<T, Error> {

    result = { _ in .failure(error) }
  }
}

extension MockFunc where Input == Void {
  public mutating func call() {
    parameters.append(())
  }

  public mutating func callAndReturn() -> Output {
    call(with: ())
    return output
  }
}
