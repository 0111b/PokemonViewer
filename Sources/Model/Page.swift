//
//  Page.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

struct Page: Equatable {
  let offset: Int
  let limit: Int

  init(limit: Int) {
    offset = 0
    self.limit = limit
  }

  func next() -> Page {
    Page(offset: offset + limit, limit: limit)
  }

  private init(offset: Int, limit: Int) {
    self.offset = offset
    self.limit = limit
  }
}
