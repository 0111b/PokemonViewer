//
//  Log.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import Foundation

import os.log

enum Log {
  // swiftlint:disable:next force_unwrapping
  private static var subsystem: String { return Bundle.main.bundleIdentifier! }
  static let networking = OSLog(subsystem: subsystem, category: "Networking")
  static let persistence = OSLog(subsystem: subsystem, category: "Persistence")
  static let general = OSLog(subsystem: subsystem, category: "General")
  @available(iOS 12.0, *)
  static let pointsOfInterest = OSLog(subsystem: subsystem, category: .pointsOfInterest)
}
