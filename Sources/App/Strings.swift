//
//  Strings.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

enum Strings {
  enum Screens {
    enum PokemonList {
      static let title = Strings.tr("Screens", "PokemonList.title")
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
