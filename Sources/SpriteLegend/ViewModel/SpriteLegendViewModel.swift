//
//  SpriteLegendViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 09.11.2020.
//

import Foundation

final class SpriteLegendViewModel {
  typealias Item = (title: String, value: String)

  let title = "Legend" // todo: localize
  var items: [Item] = [
    ("Hello", "world")
  ]
}
