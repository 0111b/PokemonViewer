//
//  XCTestCase+KeyPath.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import Foundation
import XCTest

extension XCTestCase {
  func expectation<Object, Value>(with object: Object,
                                  keyPath: KeyPath<Object, Value>,
                                  toBe value: Value) -> XCTestExpectation
  where Object: AnyObject, Value: Equatable {
    expectation(for: NSPredicate { any, _ in
      guard let object = any as? Object else { return  false }
      Swift.print("Expecting:\n \(String(describing: object[keyPath: keyPath]))\nto be:\n\(String(describing: value))")
      return object[keyPath: keyPath] == value
    }, evaluatedWith: object)
  }

  func expectation<Object, Value>(with object: Object,
                                  transform: @escaping (Object) -> Value,
                                  toBe value: Value) -> XCTestExpectation
  where Object: AnyObject, Value: Equatable {
    expectation(for: NSPredicate { any, _ in
      guard let object = any as? Object else { return  false }
      Swift.print("Expecting \(String(describing: transform(object))) to be \(String(describing: value))")
      return transform(object) == value
    }, evaluatedWith: object)
  }
}
