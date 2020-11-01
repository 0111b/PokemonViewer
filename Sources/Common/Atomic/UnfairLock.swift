//
//  UnfairLock.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

/// An `os_unfair_lock` wrapper.
final class UnfairLock {
  private let unfairLock: os_unfair_lock_t

  init() {
    unfairLock = .allocate(capacity: 1)
    unfairLock.initialize(to: os_unfair_lock())
  }

  deinit {
    unfairLock.deinitialize(count: 1)
    unfairLock.deallocate()
  }

  func lock() {
    os_unfair_lock_lock(unfairLock)
  }

  func unlock() {
    os_unfair_lock_unlock(unfairLock)
  }

  @discardableResult
  func locked<T>(_ closure: () -> T) -> T {
    lock(); defer { unlock() }
    return closure()
  }
}
