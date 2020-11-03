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
}

struct PokemonStat: Identifiable {
  let id: Identifier<PokemonStat>
  let baseStat: Int
  let effort: Int
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
