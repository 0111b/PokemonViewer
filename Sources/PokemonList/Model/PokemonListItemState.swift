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
  let highlightedRange: NSRange?

  enum LoadingState {
    case idle
    case detailsRequest(Disposable)
    case imageRequest(Disposable)
    case done
  }

  var viewState: PokemonListItemViewState {
    PokemonListItemViewState(title: attributedTitle,
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
    highlightedRange = nil
  }

  func with(detailsRequest: Disposable) -> PokemonListItemState {
    PokemonListItemState(id: identifier, types: types, image: image,
                         error: nil, loading: .detailsRequest(detailsRequest), highlightedRange: highlightedRange)
  }

  func with(detailsError: NetworkError, types: [PokemonType]) -> PokemonListItemState {
    PokemonListItemState(id: identifier, types: types, image: image,
                         error: detailsError, loading: .idle, highlightedRange: highlightedRange)
  }

  func with(imageRequest: Disposable, types: [PokemonType]) -> PokemonListItemState {
    PokemonListItemState(id: identifier, types: types, image: image,
                         error: nil, loading: .imageRequest(imageRequest), highlightedRange: highlightedRange)
  }

  func with(imageError: NetworkError) -> PokemonListItemState {
    PokemonListItemState(id: identifier, types: types, image: image,
                         error: imageError, loading: .idle, highlightedRange: highlightedRange)
  }

  func withImage(image: UIImage) -> PokemonListItemState {
    PokemonListItemState(id: identifier, types: types, image: image,
                         error: nil, loading: .done, highlightedRange: highlightedRange)
  }

  func applying(filter: PokemonListFilter) -> PokemonListItemState? {
    guard filter.hasConditions else {
      return PokemonListItemState(id: identifier, types: types, image: image,
                                  error: error, loading: loading, highlightedRange: nil)
    }
    if let range = title.range(of: filter.name, options: .caseInsensitive) {
      let nsRange = NSRange(range, in: title)
      return PokemonListItemState(id: identifier, types: types, image: image,
                                  error: error, loading: loading, highlightedRange: nsRange)
    }
    return nil
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
    default: return PokemonListItemState(id: identifier, types: types, image: image,
                                         error: nil, loading: .idle, highlightedRange: highlightedRange)
    }
  }

  func flushMemory() -> PokemonListItemState {
    PokemonListItemState(id: identifier, types: types, image: nil,
                         error: nil, loading: .idle, highlightedRange: highlightedRange)
  }

  private init(id: Identifier<Pokemon>,
               types: [PokemonType],
               image: UIImage?,
               error: NetworkError?,
               loading: PokemonListItemState.LoadingState,
               highlightedRange: NSRange?) {
    self.identifier = id
    self.types = types
    self.image = image
    self.error = error
    self.loading = loading
    self.highlightedRange = highlightedRange
  }

  private var title: String {
    identifier.rawValue
  }

  private var attributedTitle: NSAttributedString {
    let title = NSMutableAttributedString(string: self.title.capitalized)
    if let highlightedRange = self.highlightedRange {
      title.addAttribute(.backgroundColor, value: Colors.accent, range: highlightedRange)
    }
    return title
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
