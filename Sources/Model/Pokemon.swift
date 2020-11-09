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

struct PokemonSprite {
  let url: URL
  let kind: Kind

  enum Kind: Comparable {
    case frontDefault, backDefault, frontFemale, backFemale, frontShiny, backShiny, frontShinyFemale, backShinyFemale
  }

}

extension PokemonSprite.Kind {
  // swiftlint:disable colon
  var legend: String {
    typealias LocalStrings = Strings.Screens.SpriteLegend.PokemonSprite
    return [
      isFront ? LocalStrings.Front.legend : LocalStrings.Back.legend,
      isDefault ? LocalStrings.Default.legend : LocalStrings.Shiny.legend,
      isMale ? LocalStrings.Male.legend : LocalStrings.Female.legend
    ].joined()
  }

  var isFront: Bool {
    switch self {
    case .frontDefault, .frontShiny, .frontFemale, .frontShinyFemale:
      return true
    default:
      return false
    }
  }

  var isBack: Bool { !isFront }

  var isMale: Bool {
    switch self {
    case .frontDefault, .backDefault, .frontShiny, .backShiny:
      return true
    default:
      return false
    }
  }

  var isFemale: Bool { !isMale }

  var isDefault: Bool {
    switch self {
    case .frontDefault, .backDefault, .frontFemale, .backFemale:
      return true
    default:
      return false
    }
  }

  var isShiny: Bool { !isDefault }
}
