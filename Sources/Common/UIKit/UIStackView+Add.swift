//
//  UIStackView+Add.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import UIKit

extension UIStackView {
  public func addArrangedSubviews(_ views: [UIView]) {
    views.forEach { addArrangedSubview($0) }
  }

  public func removeArrangedSubviews() {
    arrangedSubviews.forEach { $0.removeFromSuperview() }
  }

}
