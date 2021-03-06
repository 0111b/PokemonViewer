//
//  PokemonType.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 08.11.2020.
//

import UIKit

enum PokemonType: String {
  case normal
  case fighting
  case flying
  case poison
  case ground
  case rock
  case bug
  case ghost
  case steel
  case fire
  case water
  case grass
  case electric
  case psychic
  case ice
  case dragon
  case dark
  case fairy
  case unknown
  case shadow
}

extension PokemonType: Identifiable {
  var id: Identifier<PokemonType> {
    Identifier(rawValue: rawValue)
  }
}

extension PokemonType {
  var color: UIColor? {
    switch self {
    case .fire: return Colors.pokemonTypeFire
    case .electric: return Colors.pokemonTypeElectric
    case .poison: return Colors.pokemonTypePoison
    case .ground: return Colors.pokemonTypeGround
    case .water: return Colors.pokemonTypeWater
    default:
      return nil
    }
  }
}
