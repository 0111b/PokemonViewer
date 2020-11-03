//
//  PokemonDetailsViewModel.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import Foundation

final class PokemonDetailsViewModel {
  init(identifier: Identifier<Pokemon>) {
    self.identifier = identifier
  }

  @Protected
  private var state: PokemonDetailsState = .idle

  // MARK: - Input -

  func viewDidLoad() {

  }

  // MARK: - Output -

  let identifier: Identifier<Pokemon>
  private let pokemonRelay = MutableObservable<PokemonDetailsViewState>(value: .empty)
  var pokemon: Observable<PokemonDetailsViewState> { pokemonRelay }

}
