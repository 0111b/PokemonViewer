//
//  PageLoadingViewState.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import Foundation

enum PageLoadingViewState {
  case loading
  case hint(String)
  case clear
}

extension PageLoadingViewState: Equatable {}
