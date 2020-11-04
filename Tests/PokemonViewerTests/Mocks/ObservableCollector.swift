//
//  ObservableCollector.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import Foundation
@testable import PokemonViewer

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
