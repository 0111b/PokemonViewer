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

  func set(state: Observable<PokemonListItemViewState>, layout: PokemonListLayout) {
    stateSubscription = state.observe(on: .main) { [weak self] state in
      guard let self = self else { return }
      self.titleLabel.text = state.title
      self.imageView.set(state: state.image)
      self.update(layout: layout, hasNoImage: state.hasNoImage)
      let colors: [UIColor] = state.title.count % 2 == 0 ? [.systemBlue] : [.systemPink, .systemYellow]
      self.didUpdatePokemonType(colors: colors)
    }
    update(layout: layout, hasNoImage: false)
  }

  func apply(style: Style) {
    layer.cornerRadius = style.cornerRadius
    titleLabel.textColor = style.titleColor
    titleLabel.font = style.titleFont
    backgroundColor = style.backgroundColor
  }

  func resetToEmptyState() {
    stateSubscription = nil
    titleLabel.text = nil
    imageView.resetToEmptyState()
  }

  override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)
    pokemonTypesLayer.frame = bounds
  }

  private func didUpdatePokemonType(colors: [UIColor]) {
    pokemonTypesLayer.colors = (colors + [.clear]).map(\.cgColor)
  }

  private func commonInit() {
    layer.masksToBounds = true
    addStretchedToBounds(subview: stackView, insets: Constants.contentInset)
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(titleLabel)
    layer.insertSublayer(pokemonTypesLayer, at: 0)
  }

  private func update(layout: PokemonListLayout, hasNoImage: Bool) {
    imageView.isHidden = false
    switch layout {
    case .list:
      stackView.axis = .horizontal
      titleLabel.isHidden = false
      imageView.isHidden = false
    case .grid where hasNoImage == true:
      stackView.axis = .vertical
      titleLabel.isHidden = false
      imageView.isHidden = true
    case .grid:
      stackView.axis = .vertical
      titleLabel.isHidden = true
      imageView.isHidden = false
    }
  }

  private var stateSubscription: Disposable?

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.setContentHuggingPriority(.required, for: .horizontal)
    label.setContentHuggingPriority(.required, for: .vertical)
    label.adjustsFontForContentSizeCategory = true
    label.textAlignment = .left
    label.numberOfLines = 0
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.7
    return label
  }()

  private lazy var imageView: RemoteImageView = {
    let image = RemoteImageView(frame: .zero)
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

  private lazy var pokemonTypesLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
    return gradientLayer
  }()

  private enum Constants {
    static let contentInset = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
  }
}
