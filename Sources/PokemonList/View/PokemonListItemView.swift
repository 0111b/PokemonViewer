//
//  PokemonListItemView.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit

typealias PokemonListItemCell = UICollectionViewContainerCell<PokemonListItemView>

final class PokemonListItemView: UIView, Resetable {
  struct Style {
    let titleColor: UIColor
    let titleFont: UIFont
    let backgroundColor: UIColor
  }

  override init(frame: CGRect) {
    super.init(frame: .zero)
    commonInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    addStretchedToBounds(subview: stackView)
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(titleLabel)
    reflectTraitCollectionChange()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    guard traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass
    else { return }
    reflectTraitCollectionChange()
  }

  func set(title: String, image: Observable<UIImage?>) {
    titleLabel.text = title
    imageSubscription = image.observe(on: .main) { [weak imageView] image in
      guard let imageView = imageView else { return }
      UIView.transition(with: imageView,
                        duration: 0.5, options: .curveEaseIn) {
        imageView.image = image ?? Images.defaultPlaceholder
      }
    }
  }

  func apply(style: Style) {
    titleLabel.textColor = style.titleColor
    titleLabel.font = style.titleFont
    backgroundColor = style.backgroundColor
  }

  func resetToEmptyState() {
    titleLabel.text = nil
    imageView.image = nil
    imageSubscription = nil
  }

  private func reflectTraitCollectionChange() {
    switch traitCollection.verticalSizeClass {
    case .regular:
      stackView.axis = .horizontal
    default:
      stackView.axis = .vertical
    }
  }

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.adjustsFontForContentSizeCategory = true
    return label
  }()

  private lazy var imageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleAspectFit
    image.widthAnchor.constraint(equalTo: image.heightAnchor).isActive = true
    return image
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .center
    stackView.spacing = 12
    return stackView
  }()

  private var imageSubscription: Disposable?
}
