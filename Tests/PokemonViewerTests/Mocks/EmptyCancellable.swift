//
//  EmptyCancellable.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import Foundation
@testable import PokemonViewer

public final class EmptyCancellable: Cancellable {
  public init() {}
  public func cancel() {}
}
