//
//  UIView+Layout.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit

extension UIView {
  public func addStretchedToBounds(subview: UIView, insets: NSDirectionalEdgeInsets = .zero) {
    subview.translatesAutoresizingMaskIntoConstraints = false
    addSubview(subview)
    NSLayoutConstraint.activate([
      subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.leading),
      subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
      trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: insets.trailing),
      bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: insets.bottom)
    ])
  }
}
