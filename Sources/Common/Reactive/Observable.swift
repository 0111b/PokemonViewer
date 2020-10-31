//
//  Observable.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import Foundation

class Observable<Value> {
  init(value: Value, onDispose: @escaping () -> Void = {}) {
    mutex = .allocate(capacity: 1)
    mutex.initialize(to: os_unfair_lock())
    self._value = value
    self.onDispose = onDispose
  }

  typealias Observer = (Value) -> Void

  var value: Value { return _value }

  func observe(on queue: DispatchQueue? = nil,
               skipCurrent: Bool = false,
               _ observer: @escaping Observer) -> Disposable {
    self.lock(); defer { self.unlock() }
    let id = UUID()
    observations[id] = (observer, queue)
    if !skipCurrent {
      observer(value)
    }
    return Disposable { [weak self] in
      self?.observations.removeValue(forKey: id)
      self?.onDispose()
    }
  }

  fileprivate var _value: Value {
    didSet {
      let newValue = _value
      observations.values.forEach { observer, dispatchQueue in
        if let queue = dispatchQueue {
          queue.async {
            observer(newValue)
          }
        } else {
          observer(newValue)
        }
      }
    }
  }

  deinit {
    onDispose()
    mutex.deinitialize(count: 1)
    mutex.deallocate()
  }

  private let onDispose: () -> Void
  private var mutex: os_unfair_lock_t
  fileprivate func lock() { os_unfair_lock_lock(mutex) }
  fileprivate func unlock() { os_unfair_lock_unlock(mutex) }
  private var observations: [UUID: (Observer, DispatchQueue?)] = [:]
}

final class MutableObservable<Value>: Observable<Value> {
  override var value: Value {
    get { return super.value }
    set {
      self.lock(); defer { self.unlock() }
      _value = newValue
    }
  }
}
