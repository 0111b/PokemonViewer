//
//  Protected.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

@propertyWrapper
@dynamicMemberLookup
final class Protected<T> {

  init(wrappedValue: T) {
    value = wrappedValue
  }

  /// The contained value. Unsafe for anything more than direct read or write.
  var wrappedValue: T {
    get { lock.locked { value } }
    set { lock.locked { value = newValue } }
  }

  var projectedValue: Protected<T> { self }

  func read<U>(_ closure: (T) -> U) -> U {
    lock.locked { closure(self.value) }
  }

  @discardableResult
  func write<U>(_ closure: (inout T) -> U) -> U {
    lock.locked { closure(&self.value) }
  }

  subscript<Property>(dynamicMember keyPath: WritableKeyPath<T, Property>) -> Property {
    get { lock.locked { value[keyPath: keyPath] } }
    set { lock.locked { value[keyPath: keyPath] = newValue } }
  }

  private let lock = UnfairLock()
  private var value: T
}
