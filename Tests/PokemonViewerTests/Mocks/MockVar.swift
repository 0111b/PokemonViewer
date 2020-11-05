//
//  MockVar.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import Foundation

final public class MockVar<T> {
  public private(set) var assignments = [T]()
  private(set) var didSet: ((T) -> Void)?
  private var returnValue = Value.empty

  public init() {
  }

  func assign(_ value: T) {
    assignments.append(value)
  }

  func `return`() -> T {
    returnValue.return()
  }
}

extension MockVar {
  @discardableResult
  public func `returns`(_ value: T) -> Self {
    returnValue.set(value)
    return self
  }

  @discardableResult
  public func thenReturns(_ value: T) -> Self {
    returnValue.append(value)
    return self
  }

  @discardableResult
  public func whenSet(_ callback: @escaping (T) -> Void) -> Self {
    didSet = callback
    return self
  }
}

extension MockVar {
  private enum Value {
    case empty
    case one(T)
    case many([T])

    mutating func set(_ value: T) {
      self = .one(value)
    }

    mutating func append(_ value: T) {
      switch self {
      case .empty:
        self = .one(value)
      case .one(let first):
        self = .many([first, value])
      case .many(let values):
        self = .many(values + [value])
      }
    }

    mutating func `return`() -> T {
      switch self {
      case .empty:
        fatalError("Return value not set")
      case .one(let value):
        return value
      case .many(let values) where values.isEmpty:
        fatalError("No return values left")
      case .many(let values):
        let value = values[0]
        self = .many(Array(values.dropFirst()))
        return value
      }
    }
  }
}
