//
//  Mock.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import Foundation

@propertyWrapper
final public class Mock<T> {
  public var projectedValue = MockVar<T>()
  public var wrappedValue: T {
    get {
      projectedValue.return()
    }
    set {
      projectedValue.assign(newValue)
      projectedValue.didSet?(newValue)
    }
  }

  public init() {
  }
}
