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
    internal init(titleColor: UIColor, titleFont: UIFont, backgroundColor: UIColor, cornerRadius: CGFloat = 10) {
      self.titleColor = titleColor
      self.titleFont = titleFont
      self.backgroundColor = backgroundColor
      self.cornerRadius = cornerRadius
    }

    let titleColor: UIColor
    let titleFont: UIFont
    let backgroundColor: UIColor
    let cornerRadius: CGFloat
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
    layer.masksToBounds = true
    addStretchedToBounds(subview: stackView, insets: Constants.contentInset)
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(titleLabel)
  }

  func set(title: String, image: Observable<UIImage?>, axis: NSLayoutConstraint.Axis) {
    titleLabel.text = title
    stackView.axis = axis
    switch axis {
    case .horizontal:
      titleLabel.textAlignment = .left
    case .vertical:
      titleLabel.textAlignment = .center
    @unknown default:
      titleLabel.textAlignment = .center
    }
    imageSubscription = image.observe(on: .main) { [weak imageView] image in
      guard let imageView = imageView else { return }
      UIView.transition(with: imageView,
                        duration: 0.5, options: .curveEaseIn) {
        imageView.image = image ?? Images.defaultPlaceholder?.withRenderingMode(.alwaysTemplate)
      }
    }
  }

  func apply(style: Style) {
    layer.cornerRadius = style.cornerRadius
    titleLabel.textColor = style.titleColor
    titleLabel.font = style.titleFont
    backgroundColor = style.backgroundColor
  }

  func resetToEmptyState() {
    titleLabel.text = nil
    imageView.image = nil
    imageSubscription = nil
  }

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.setContentHuggingPriority(.required, for: .horizontal)
    label.setContentHuggingPriority(.required, for: .vertical)
    label.adjustsFontForContentSizeCategory = true
    label.numberOfLines = 0
    return label
  }()

  private lazy var imageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleAspectFit
    image.widthAnchor.constraint(equalTo: image.heightAnchor).isActive = true
    image.tintColor = Colors.accent
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

  private enum Constants {
    static let contentInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
  }
}
