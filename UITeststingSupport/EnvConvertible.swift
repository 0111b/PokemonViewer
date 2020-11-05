//
//  EnvConvertible.swift
//  UITeststingSupport
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import Foundation

protocol Defaultable {
  static var `default`: Self { get }
}

protocol EnvironmentConvertible: RawRepresentable, Defaultable where Self.RawValue == String {
  static var envKey: String { get }
}

extension EnvironmentConvertible {
  typealias Environment = [String: String]

  static var envKey: String { String(describing: type(of: self)) }

  static func decode(from env: Environment, key: String = Self.envKey) -> Self {
    guard let rawValue = env[envKey] else {
      return Self.default
    }
    return Self.init(rawValue: rawValue) ?? Self.default
  }

  func encode(to env: inout Environment) {

  }

}
