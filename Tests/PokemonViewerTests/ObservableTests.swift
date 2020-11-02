//
//  ObservableTests.swift
//  PokemonViewerTests
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import XCTest
@testable import PokemonViewer

final class ObservableTests: XCTestCase {

  func testValues() {
    let observable = MutableObservable<Int>(value: 0)
    let collector = ObservableCollector(observable: observable)
    observable.value = 1
    observable.value = 2
    XCTAssertEqual(collector.values, [0, 1, 2])
  }

  func testSkipCurrent() {
    let observable = MutableObservable<Int>(value: 0)
    let collector = ObservableCollector(observable: observable, skipCurrent: true)
    observable.value = 1
    observable.value = 2
    XCTAssertEqual(collector.values, [1, 2])
  }

  func testDisposeDestructor() {
    var wasDisposed = false
    _ = MutableObservable<Int>(value: 0) {
      wasDisposed = true
    }
    XCTAssertTrue(wasDisposed)
  }

}

final class ObservableCollector<Value> {
  init(observable: Observable<Value>, skipCurrent: Bool = false) {
    disposable = observable.observe(skipCurrent: skipCurrent) { [unowned self] value in
      self.values.append(value)
    }
  }
  private var disposable = Disposable.empty
  private(set) var values = [Value]()
  var last: Value { return values.last! } // swiftlint:disable:this force_unwrapping
}

extension ObservableCollector where Value: Equatable {
  func predicate(for values: [Value]) -> NSPredicate {
    NSPredicate { any, _ in
      guard let collector = any as? ObservableCollector<Value> else { return  false }
      return collector.values == values
    }
  }
}
