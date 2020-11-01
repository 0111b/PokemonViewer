//
//  PokemonAPIService.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

protocol PokemonAPIServiceProvider {
  var pokemonAPIService: PokemonAPIService { get }
}

protocol PokemonAPIService {
  func list(page: Page,
            cachePolicy: RequestCachePolicy,
            completion: @escaping (NetworkResult<PokemonAPI.PokemonPage>) -> Void) -> Disposable

  func details(for identifier: Identifier<Pokemon>,
               cachePolicy: RequestCachePolicy,
               completion: @escaping (NetworkResult<Pokemon>) -> Void) -> Disposable
}

final class PokemonAPIServiceImp: APIService, PokemonAPIService {

  func list(page: Page,
            cachePolicy: RequestCachePolicy,
            completion: @escaping (NetworkResult<PokemonAPI.PokemonPage>) -> Void) -> Disposable {
    return self.obtain(location: .list(page: page),
                       cachePolicy: cachePolicy) { (result: PokemonAPI.DTO.PokemonList) -> Void in
      completion(result.map { dto in
        PokemonAPI.PokemonPage(count: dto.count,
                               items: dto.results.map { .init(rawValue: $0.name) })
      })
    }
  }

  func details(for identifier: Identifier<Pokemon>,
               cachePolicy: RequestCachePolicy,
               completion: @escaping (NetworkResult<Pokemon>) -> Void) -> Disposable {
    return self.obtain(location: .details(identifier: identifier),
                       cachePolicy: cachePolicy) { (result: NetworkResult<PokemonAPI.DTO.PokemonDetails>) -> Void in
      completion(result.map { Pokemon(dto: $0) })
    }
  }
}

private extension HTTPLocation {
  static func list(page: Page) -> HTTPLocation {
    HTTPLocation(urlPath: "/api/v2/pokemon",
                 queryItems: [
                  "limit": String(page.limit),
                  "offset": String(page.offset)
                 ]).accept(.json)
  }

  static func details(identifier: Identifier<Pokemon>) -> HTTPLocation {
    HTTPLocation(urlPath: "/api/v2/pokemon/\(identifier.rawValue)")
      .accept(.json)
  }
}

private extension Pokemon {
  init(dto: PokemonAPI.DTO.PokemonDetails) {
    id = .init(rawValue: dto.name)
    height = dto.height
    weight = dto.weight
    sprites = [
      dto.sprites.frontDefault,
      dto.sprites.backDefault,
      dto.sprites.frontShiny,
      dto.sprites.backShiny,
      dto.sprites.frontFemale,
      dto.sprites.backFemale,
      dto.sprites.frontShinyFemale,
      dto.sprites.backShinyFemale
    ].compactMap { $0 }
    stats = dto.stats.map { PokemonStat(dto: $0) }
    abilities = dto.abilities
      .sorted { $0.slot < $1.slot }
      .map { PokemonAbility(id: .init(rawValue: $0.ability.name)) }
    types = dto.types
      .sorted { $0.slot < $1.slot }
      .map { PokemonType(id: .init(rawValue: $0.type.name)) }
  }
}

private extension PokemonStat {
  init(dto: PokemonAPI.DTO.PokemonStat) {
    id = .init(rawValue: dto.stat.name)
    baseStat = dto.baseStat
    effort = dto.effort
  }
}
