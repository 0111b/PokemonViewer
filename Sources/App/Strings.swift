//
//  Strings.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

// swiftlint:disable nesting
enum Strings {
  enum Screens {

    enum PokemonList {
      static let title = Strings.tr("Screens", "PokemonList.title")
      static let noMoreItems = Strings.tr("Screens", "PokemonList.noMoreItems")

      enum Error {
        static let transport = Strings.tr("Screens", "PokemonList.Error.transport")
        static let `default` = Strings.tr("Screens", "PokemonList.Error.default")
      }

      enum Search {
        static let placeholder = Strings.tr("Screens", "PokemonList.Search.placeholder")
        static let noMatch = Strings.tr("Screens", "PokemonList.Search.noMatch")
      }

    }

    enum EmptyPokemonDetails {
      enum Hint {
        static let noItemSelected = Strings.tr("Screens", "EmptyPokemonDetails.Hint.noItemSelected")
      }

    }

    enum PokemonDetails {
      enum Error {
        static let transport = Strings.tr("Screens", "PokemonDetails.Error.transport")
        static let `default` = Strings.tr("Screens", "PokemonDetails.Error.default")
        static let cta = Strings.tr("Screens", "PokemonDetails.Error.cta")
      }

      enum Header {
        static let sprites = Strings.tr("Screens", "PokemonDetails.Header.sprites")
        static let stats = Strings.tr("Screens", "PokemonDetails.Header.stats")
        static let abilities = Strings.tr("Screens", "PokemonDetails.Header.abilities")
        static let types = Strings.tr("Screens", "PokemonDetails.Header.types")
      }

      enum Content {
        static let listSeparator = Strings.tr("Screens", "PokemonDetails.Content.listSeparator")
        static let weight = Strings.tr("Screens", "PokemonDetails.Content.weight")
        static let height = Strings.tr("Screens", "PokemonDetails.Content.height")

        static func statTitleFormat(name: String, level: Int) -> String {
          Strings.tr("Screens", "PokemonDetails.Content.statTitleFormat", name, String(describing: level))
        }

        static let health = Strings.tr("Screens", "PokemonDetails.Content.health")
        static let attack = Strings.tr("Screens", "PokemonDetails.Content.attack")
        static let defense = Strings.tr("Screens", "PokemonDetails.Content.defense")
        static let specialAttack = Strings.tr("Screens", "PokemonDetails.Content.specialAttack")
        static let specialDefense = Strings.tr("Screens", "PokemonDetails.Content.specialDefense")
        static let speed = Strings.tr("Screens", "PokemonDetails.Content.speed")

      }
    }

  }
}

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {
  static let bundle: Bundle = {
    return Bundle(for: BundleToken.self)
  }()
}
