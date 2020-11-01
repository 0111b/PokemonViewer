//
//  OperationContainer.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

struct OperationContainer: Cancellable {
  let operations: [Operation]

  func cancel() {
    operations.forEach { $0.cancel() }
  }
}
