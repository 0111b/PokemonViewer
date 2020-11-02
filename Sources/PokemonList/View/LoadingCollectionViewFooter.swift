//
//  LoadingCollectionViewFooter.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import UIKit

final class LoadingCollectionViewFooter: UICollectionReusableView, CollectionViewFooter {

  override init(frame: CGRect) {
    super.init(frame: .zero)
    commonInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    addStretchedToBounds(subview: hintLabel)
    addStretchedToBounds(subview: activityIndicator)
    backgroundColor = Colors.background
  }

  func update(with state: LoadingViewState) {
    switch state {
    case .clear:
      activityIndicator.stopAnimating()
      hintLabel.text = nil
    case .loading:
      hintLabel.text = nil
      activityIndicator.startAnimating()
    case .hint(let message):
      hintLabel.text = message
      activityIndicator.stopAnimating()
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    update(with: .clear)
  }

  private lazy var hintLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.adjustsFontForContentSizeCategory = true
    label.textColor = Colors.primaryText
    label.font = Fonts.footnote
    label.textAlignment = .center
    return label
  }()

  private lazy var activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .gray)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.color = Colors.accent
    return indicator
  }()
}
