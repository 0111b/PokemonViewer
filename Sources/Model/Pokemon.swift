//
//  Pokemon.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

struct Pokemon: Identifiable {
  let id: Identifier<Pokemon>
  let height: Int
  let weight: Int
  let sprites: [PokemonSprite]
  let stats: [PokemonStat]
  let abilities: [PokemonAbility]
  let types: [PokemonType]

  var name: String { id.rawValue.capitalized }
}

struct PokemonStat: Identifiable {
  let id: Identifier<PokemonStat>
  let kind: Kind
  let baseStat: Int
  let effort: Int

  enum Kind {
    case custom(String)
    case health, attack, defense, specialAttack, specialDefense, speed
  }
}

struct PokemonAbility: Identifiable {
  let id: Identifier<PokemonAbility>
}

struct PokemonType: Identifiable {
  let id: Identifier<PokemonType>
}

struct PokemonSprite {
  let url: URL
  let kind: Kind

  enum Kind: Comparable {
    case frontDefault, backDefault, frontFemale, backFemale, frontShiny, backShiny, frontShinyFemale, backShinyFemale
  }

}
