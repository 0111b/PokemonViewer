//
//  PokemonAPI.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

enum PokemonAPI {
  enum DTO {
    struct PageResponse<Value: Decodable>: Decodable {
      let count: Int
      let results: [Value]
    }

    struct Named<Value: Decodable>: Decodable {
      let name: Value
    }

    typealias PokemonList = NetworkResult<PageResponse<Named<Identifier<Pokemon>>>>

    struct PokemonDetails: Decodable {
      let name: String
      let height: Int
      let weight: Int
      let sprites: PokemonSprites
      let stats: [PokemonStat]
      let abilities: [PokemonAbility]
      let types: [PokemonType]
    }

    struct PokemonSprites: Decodable {
      let backDefault: URL?
      let backFemale: URL?
      let backShiny: URL?
      let backShinyFemale: URL?
      let frontDefault: URL?
      let frontFemale: URL?
      let frontShiny: URL?
      let frontShinyFemale: URL?
    }

    struct PokemonStat: Decodable {
      let baseStat: Int
      let effort: Int
      let stat: Named<Identifier<PokemonViewer.PokemonStat>>
    }

    struct PokemonAbility: Decodable {
      let slot: Int
      let ability: Named<Identifier<PokemonViewer.PokemonAbility>>
    }

    struct PokemonType: Decodable {
      let slot: Int
      let type: Named<Identifier<PokemonViewer.PokemonType>>
    }
  }

  struct PokemonPage {
    let count: Int
    let items: [Identifier<Pokemon>]
  }
}
