//
//  PokemonListViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import Foundation

final class PokemonListViewModel {

  init() {

  }

  // MARK: - Input -
  func viewDidLoad() {

  }

  // MARK: - Output -

  private let viewStateRelay = MutableObservable<PokemonListViewState>(value: .idle)
  var viewState: Observable<PokemonListViewState> { viewStateRelay }
}
