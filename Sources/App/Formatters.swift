//
//  Formatters.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import Foundation


extension MassFormatter {
  static let `default`:  MassFormatter = {
    let formatter = MassFormatter()
    formatter.unitStyle = .long
    formatter.isForPersonMassUse = true
    return formatter
  }()

  func string(fromHectograms numberInHectograms: Int) -> String {
    string(fromKilograms: Double(numberInHectograms) / 10.0)
  }
}

extension LengthFormatter {
  static let `default`:  LengthFormatter = {
    let formatter = LengthFormatter()
    formatter.unitStyle = .long
    formatter.isForPersonHeightUse = true
    return formatter
  }()

  func string(fromDecimetres numberInDecimetres: Int) -> String {
    string(fromMeters: Double(numberInDecimetres) / 10.0)
  }
}
