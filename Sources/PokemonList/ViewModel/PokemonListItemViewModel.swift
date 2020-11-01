//
//  PokemonListItemViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import UIKit

final class PokemonListItemViewModel {
  init(id: Identifier<Pokemon>) {
   identifier = id
  }
  private let identifier: Identifier<Pokemon>

  var title: String { identifier.rawValue }
  let image = Observable<UIImage?>(value: nil)
}
