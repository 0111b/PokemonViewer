//
//  Observable.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import Foundation

class Observable<Value> {
  init(value: Value, onDispose: @escaping () -> Void = {}) {
    self._value = value
    self.onDispose = onDispose
  }

  typealias Observer = (Value) -> Void

  var value: Value { return mutex.locked { _value }}

  func observe(on queue: DispatchQueue? = nil,
               skipCurrent: Bool = false,
               _ observer: @escaping Observer) -> Disposable {
    mutex.lock(); defer { mutex.unlock() }
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
  }

  private let onDispose: () -> Void
  fileprivate var mutex = UnfairLock()
  private var observations: [UUID: (Observer, DispatchQueue?)] = [:]
}

final class MutableObservable<Value>: Observable<Value> {
  override var value: Value {
    get { return super.value }
    set {
      mutex.locked {
        _value = newValue
      }
    }
  }
}
