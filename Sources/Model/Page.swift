//
//  Page.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

struct Page: Equatable {
  let offset: UInt
  let limit: UInt

  init(limit: UInt) {
    offset = 0
    self.limit = limit
  }

  func next() -> Page {
    Page(offset: offset + limit, limit: limit)
  }

  var isFirst: Bool { offset == 0 }

  private init(offset: UInt, limit: UInt) {
    self.offset = offset
    self.limit = limit
  }
}
