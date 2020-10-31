//
//  PockemonViewerTests.swift
//  PockemonViewerTests
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import XCTest
@testable import PockemonViewer

final class DisposableTests: XCTestCase {

  func testDisposed() throws {
    var isDisposeCalled = false
    let localScope: () -> Void = {
      _ = Disposable {
        isDisposeCalled = true
      }
    }
    localScope()
    XCTAssertTrue(isDisposeCalled)
  }

}
