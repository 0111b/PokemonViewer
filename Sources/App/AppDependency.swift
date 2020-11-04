//
//  AppDependency.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import Foundation
import UITeststingSupport

final class AppDependency {
  init() {
    #if DEBUG
    if CommandLine.arguments.contains(AppTestConfiguration.testingFlag) {
      isTestingEnabled = true
    } else {
      isTestingEnabled = false
    }
    #else
    isTestingEnabled = false
    #endif
  }

  private let isTestingEnabled: Bool
  private let testConfig = AppTestConfiguration(raw: ProcessInfo.processInfo.environment)

  lazy var imageService: ImageService = {
    if isTestingEnabled {
      return TestImageService(config: testConfig.imageService)
    } else {
      return ImageServiceImp(network: imageNetwork)
    }
  }()

  lazy var pokemonAPIService: PokemonAPIService = {
    if isTestingEnabled {
      return TestPokemonAPIService(config: testConfig.pokemonService)
    } else {
      return PokemonAPIServiceImp(requestBuilder: RequestBuilder(baseURL: "https://pokeapi.co/api/v2"),
                                  network: apiNetwork)
    }
  }()

  private var imageNetwork: NetworkService { networkService }
  private var apiNetwork: NetworkService { networkService }

  private lazy var networkService: NetworkService = {
    var config = URLSessionConfiguration.default
    config.urlCache = nil
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    let transport: HTTPTransport = URLSession(configuration: config)
    let networkCache: NetworkCache = URLCache(memoryCapacity: Constants.defaultMemoryCapacity,
                                              diskCapacity: Constants.defaultDiskCapacity,
                                              diskPath: "NetworkService")
    return NetworkServiceImp(transport: transport,
                             cache: networkCache)
  }()

  private enum Constants {
    static let defaultMemoryCapacity: Int = 10*1024*1024
    static let defaultDiskCapacity: Int = 50*1024*1024
  }
}

extension AppDependency: PokemonAPIServiceProvider {}

extension AppDependency: ImageServiceProvider {}
