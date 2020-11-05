//
//  Identifier.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 01.11.2020.
//

import Foundation

protocol Identifiable {
  associatedtype RawIdentifier: Codable = String

  var id: Identifier<Self> { get }
}

struct Identifier<Value: Identifiable> {
  let rawValue: Value.RawIdentifier

  init(rawValue: Value.RawIdentifier) {
    self.rawValue = rawValue
  }
}

extension Identifier: CustomStringConvertible {
  var description: String {
    String(describing: rawValue)
  }
}

extension Identifier: Equatable where Value.RawIdentifier: Equatable {}

extension Identifier: Hashable where Value.RawIdentifier: Hashable {}

extension Identifier: Decodable where Value.RawIdentifier: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    rawValue = try container.decode(Value.RawIdentifier.self)
  }
}

extension Identifier: Encodable where Value.RawIdentifier: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(rawValue)
  }
}

extension Identifier: ExpressibleByIntegerLiteral where Value.RawIdentifier == Int {
  typealias IntegerLiteralType = Int

  init(integerLiteral value: Int) {
    rawValue = value
  }
}
