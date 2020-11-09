//
//  PokemonListItemViewState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 08.11.2020.
//

import UIKit

struct PokemonListItemViewState {
  let title: NSAttributedString
  let typeColors: [UIColor]
  let hasNoImage: Bool
  let image: RemoteImageViewState

  static let empty = PokemonListItemViewState(title: NSAttributedString(), typeColors: [],
                                              hasNoImage: false, image: .empty)
}
