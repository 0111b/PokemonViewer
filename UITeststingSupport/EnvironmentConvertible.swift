//
//  EnvironmentConvertible.swift
//  UITeststingSupport
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import Foundation

protocol Defaultable {
  static var `default`: Self { get }
}

protocol EnvironmentConvertible {
  typealias Environment = [String: String]

  static func decode(from env: Environment) -> Self

  func encode(to env: inout Environment)

}

extension EnvironmentConvertible where Self: RawRepresentable, Self.RawValue == String, Self: Defaultable {

  static var envKey: String { String(describing: self) }

  static func decode(from env: Environment) -> Self {
    guard let rawValue = env[envKey] else {
      return Self.default
    }
    return Self.init(rawValue: rawValue) ?? Self.default
  }

  func encode(to env: inout Environment) {
    env[Self.envKey] = rawValue
  }
}
