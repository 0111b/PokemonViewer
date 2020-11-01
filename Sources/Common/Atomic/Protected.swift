//
//  Protected.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

@propertyWrapper
final class Protected<T> {

  init(wrappedValue: T) {
    value = wrappedValue
  }

  /// The contained value. Unsafe for anything more than direct read or write.
  var wrappedValue: T {
    get { lock.locked { value } }
    set { lock.locked { value = newValue } }
  }

  private let lock = UnfairLock()
  private var value: T
}
