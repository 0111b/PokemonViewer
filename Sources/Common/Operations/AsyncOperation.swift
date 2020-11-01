//
//  AsyncOperation.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

class AsyncOperation: Operation {

  //Override in the sublasses
  func run() {
    state = .finished
  }

  enum State: String {
    case ready = "Ready"
    case executing = "Executing"
    case finished = "Finished"
    fileprivate var keyPath: String {
      return "is" + self.rawValue
    }
  }

  override var isAsynchronous: Bool { true }

  var state = State.ready {
    willSet {
      willChangeValue(forKey: state.keyPath)
      willChangeValue(forKey: newValue.keyPath)
    }
    didSet {
      didChangeValue(forKey: oldValue.keyPath)
      didChangeValue(forKey: state.keyPath)
    }
  }

  override var isExecuting: Bool { state == .executing }

  override var isFinished: Bool { state == .finished }

  override var isReady: Bool { super.isReady && state == .ready }

  override func start() {
    if self.isCancelled {
      state = .finished
    } else {
      state = .ready
      main()
    }
  }

  override func main() {
    if self.isCancelled {
      state = .finished
    } else {
      state = .executing
      run()
    }
  }
}

final class AsyncBlockOperation: AsyncOperation {
  typealias Completion = () -> Void
  typealias Work = (@escaping Completion) -> Void

  init(work: @escaping Work) {
    self.work = work
  }

  private let work: Work

  override func run() {
    let completion: Completion = { [unowned self] in
      self.state = .finished
    }
    work(completion)
  }
}
