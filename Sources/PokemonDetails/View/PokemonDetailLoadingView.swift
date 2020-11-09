//
//  PokemonDetailLoadingView.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import UIKit

final class PokemonDetailLoadingView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    backgroundColor = Colors.background
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(activityIndicator)
    NSLayoutConstraint.activate([
      activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
  }

  override var isHidden: Bool {
    get { super.isHidden }
    set {
      super.isHidden = newValue
      if !newValue {
        activityIndicator.startAnimating()
      }
    }
  }

  private lazy var activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .gray)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.color = Colors.accent
    return indicator
  }()
}
