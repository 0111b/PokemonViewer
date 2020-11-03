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

    }


    enum EmptyPokemonDetails {
      enum Hint {
        static let noItemSelected = Strings.tr("Screens", "EmptyPokemonDetails.Hint.noItemSelected")
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
