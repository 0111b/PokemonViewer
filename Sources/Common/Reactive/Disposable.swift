//
//  Disposable.swift
//  PockemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import Foundation

final class Disposable {

  class var empty: Disposable { return Disposable({}) }

  init(_ dispose: @escaping () -> Void) {
    self.dispose = dispose
  }

  deinit {
    dispose()
  }

  private let dispose: () -> Void

}
