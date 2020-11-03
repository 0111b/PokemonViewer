//
//  EmptyPokemonDetailsViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import Foundation

final class EmptyPokemonDetailsViewModel {

  enum Hint {
    case noItemSelected
  }

  init(hint: Hint) {
    self.hint = hint
  }

  private let hint: Hint

  var hintMessage: String {
    switch self.hint {
    case .noItemSelected: return Strings.Screens.EmptyPokemonDetails.Hint.noItemSelected
    }
  }
}
