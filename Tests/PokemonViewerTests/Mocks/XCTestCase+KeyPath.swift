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
      return object[keyPath: keyPath] == value
    }, evaluatedWith: object)
  }
}
