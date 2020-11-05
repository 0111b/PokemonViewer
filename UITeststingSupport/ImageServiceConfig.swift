//
//  ImageServiceConfig.swift
//  UITeststingSupport
//
//  Created by Alexandr Goncharov on 05.11.2020.
//

import Foundation

public enum ImageServiceConfig: String, EnvironmentConvertible, Defaultable {
  case error
  case sampleValue

  public static let `default`: ImageServiceConfig = .sampleValue
}
