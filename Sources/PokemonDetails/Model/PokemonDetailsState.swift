//
//  PokemonDetailsState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import Foundation

enum PokemonDetailsState {
  case idle
  case loading(Disposable)
  case error(NetworkError)
  case done(Pokemon)
}
