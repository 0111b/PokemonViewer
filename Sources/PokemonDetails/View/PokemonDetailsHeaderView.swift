//
//  PokemonDetailsHeaderView.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 09.11.2020.
//

import UIKit

final class PokemonDetailsHeaderView: UIView {

  @available(*, unavailable, message: "Use `init(title:rightView)` instead")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(title: String, rightView: UIView = UIView()) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = Constants.backgroundColor
    addSubview(titleLabel)
    rightView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(rightView)
    layer.insertSublayer(bottomLineLayer, at: 0)
    layer.mask = maskLayer
    self.title = title
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.contentInset.leading),
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.contentInset.top),
      bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.contentInset.bottom),
      rightView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
      rightView.leadingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 1.0),
      trailingAnchor.constraint(equalTo: rightView.trailingAnchor, constant: Constants.contentInset.trailing)
    ])
  }

  var title: String? {
    get { titleLabel.text }
    set { titleLabel.text = newValue }
  }

  override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)
    let lineHeight: CGFloat = 1
    bottomLineLayer.frame = CGRect(x: 0, y: bounds.height - lineHeight,
                                   width: bounds.width, height: lineHeight)
    maskLayer.path = UIBezierPath(roundedRect: bounds,
                                  byRoundingCorners: [.topLeft, .topRight],
                                  cornerRadii: CGSize(width: 10, height: 10)).cgPath
  }

  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    label.numberOfLines = 1
    label.textAlignment = .left
    label.textColor = Constants.titleColor
    label.font = Constants.titleFont
    return label
  }()

  private lazy var bottomLineLayer: CALayer = {
    let layer = CALayer()
    layer.backgroundColor = Constants.titleColor.cgColor
    return layer
  }()

  private lazy var maskLayer = CAShapeLayer()

  private enum Constants {
    static let backgroundColor = Colors.sectionBackground
    static let titleFont = Fonts.header
    static let titleColor = Colors.secondaryText
    static let contentInset = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
  }
}
