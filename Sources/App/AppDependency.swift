//
//  AppDependency.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import Foundation

final class AppDependency {
  init() {

  }

  lazy var imageService: ImageService = {
    ImageServiceImp(network: imageNetwork)
  }()

  lazy var pokemonAPIService: PokemonAPIService = {
    PokemonAPIServiceImp(requestBuilder: RequestBuilder(baseURL: "https://pokeapi.co/api/v2"),
                         network: apiNetwork)
  }()

  private var imageNetwork: NetworkService { networkService }
  private var apiNetwork: NetworkService { networkService }

  private lazy var networkService: NetworkService = {
    var config = URLSessionConfiguration.default
    config.urlCache = nil
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    let transport: HTTPTransport = URLSession(configuration: config)
    //    let networkCache: NetworkCache = DisabledNetworkCache()
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
