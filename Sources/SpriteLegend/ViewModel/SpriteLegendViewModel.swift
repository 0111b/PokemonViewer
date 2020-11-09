//
//  SpriteLegendViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 09.11.2020.
//

import Foundation

final class SpriteLegendViewModel {
  typealias Item = (title: String, value: String)

  let title = Strings.Screens.SpriteLegend.title

  let items: [Item] = {
    typealias LocalStrings = Strings.Screens.SpriteLegend.PokemonSprite
    return [
      (LocalStrings.Front.kind, LocalStrings.Front.legend),
      (LocalStrings.Back.kind, LocalStrings.Back.legend),
      (LocalStrings.Default.kind, LocalStrings.Default.legend),
      (LocalStrings.Shiny.kind, LocalStrings.Shiny.legend),
      (LocalStrings.Male.kind, LocalStrings.Male.legend),
      (LocalStrings.Female.kind, LocalStrings.Female.legend)
    ]
  }()
}
