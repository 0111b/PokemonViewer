//
//  PokemonDetailsViewState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import Foundation

enum PokemonDetailsViewState {
  case idle
  case error(String)
  case loading
  case data(Pokemon)
}
