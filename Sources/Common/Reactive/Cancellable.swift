//
//  Cancellable.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

public protocol Cancellable {
  func cancel()
}

public final class AnyCancellable: Cancellable {

  class var empty: Cancellable { AnyCancellable(disposable: .empty) }

  init(dispose: @escaping () -> Void) {
    disposable = Disposable(dispose)
  }

  init(disposable: Disposable) {
    self.disposable = disposable
  }

  public func cancel() {
    disposable = nil
  }

  private var disposable: Disposable?
}
