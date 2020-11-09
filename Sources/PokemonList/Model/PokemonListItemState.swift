//
//  PokemonListItemState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import UIKit

struct PokemonListItemState {

  let identifier: Identifier<Pokemon>
  let types: [PokemonType]
  let image: UIImage?
  let error: NetworkError?
  let loading: LoadingState

  enum LoadingState {
    case idle
    case detailsRequest(Disposable)
    case imageRequest(Disposable)
    case done
  }

  var viewState: PokemonListItemViewState {
    PokemonListItemViewState(title: identifier.rawValue.capitalized,
                             typeColors: types.compactMap(\.color),
                             hasNoImage: hasNoImage,
                             image: imageState)
  }

  init(id: Identifier<Pokemon>) {
    self.identifier = id
    types = []
    loading = .idle
    error = nil
    image = nil
  }

  func with(detailsRequest: Disposable) -> PokemonListItemState {
    PokemonListItemState(id: identifier, types: types, image: image,
                         error: nil, loading: .detailsRequest(detailsRequest))
  }

  func with(detailsError: NetworkError, types: [PokemonType]) -> PokemonListItemState {
    PokemonListItemState(id: identifier, types: types, image: image,
                         error: detailsError, loading: .idle)
  }

  func with(imageRequest: Disposable, types: [PokemonType]) -> PokemonListItemState {
    PokemonListItemState(id: identifier, types: types, image: image,
                         error: nil, loading: .imageRequest(imageRequest))
  }

  func with(imageError: NetworkError) -> PokemonListItemState {
    PokemonListItemState(id: identifier, types: types, image: image,
                         error: imageError, loading: .idle)
  }

  func withImage(image: UIImage) -> PokemonListItemState {
    PokemonListItemState(id: identifier, types: types, image: image,
                         error: nil, loading: .done)
  }

  func canStartRequest() -> Bool {
    switch loading {
    case .idle: return true
    default: return false
    }
  }

  func canceled() -> PokemonListItemState {
    switch loading {
    case .done: return self
    default: return PokemonListItemState(id: identifier, types: types, image: image, error: nil, loading: .idle)
    }
  }

  func flushMemory() -> PokemonListItemState {
    PokemonListItemState(id: identifier, types: types, image: nil, error: nil, loading: .idle)
  }

  private init(id: Identifier<Pokemon>,
               types: [PokemonType],
               image: UIImage?,
               error: NetworkError?,
               loading: PokemonListItemState.LoadingState) {
    self.identifier = id
    self.types = types
    self.image = image
    self.error = error
    self.loading = loading
  }

  private var isLoading: Bool {
    switch loading {
    case .idle, .done: return false
    default:
      return true
    }
  }

  private var hasNoImage: Bool {
    if isLoading { return false }
    return error != nil
  }

  private var imageState: RemoteImageViewState {
    if isLoading { return .loading }
    if let image = self.image { return .image(image) }
    return error == nil ? .empty : .image(Images.defaultPlaceholder)
  }
}


private extension PokemonType {
  var color: UIColor? {
    switch self {
    case .fire: return Colors.pokemonTypeFire
    case .electric: return Colors.pokemonTypeElectric
    case .poison: return Colors.pokemonTypePoison
    case .ground: return Colors.pokemonTypeGround
    case .water: return Colors.pokemonTypeWater
    default:
      return nil
    }
  }
}
