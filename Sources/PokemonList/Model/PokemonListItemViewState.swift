//
//  PokemonListItemViewState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 08.11.2020.
//

import UIKit

struct PokemonListItemViewState {
  let name: String
  let typeColors: [UIColor]
  let isLoading: Bool
  let isError: Bool
  let image: UIImage?
}
