//
//  PokemonDetailsHeaderView.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 09.11.2020.
//

import UIKit

final class PokemonDetailsHeaderView: UIView {

  convenience init(title: String) {
    self.init(frame: .zero)
    self.title = title
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  var title: String? {
    get { titleLabel.text }
    set { titleLabel.text = newValue }
  }

  override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)
    let lineHeight: CGFloat = 2
    bottomLineLayer.frame = CGRect(x: 0, y: bounds.height - lineHeight,
                                   width: bounds.width, height: lineHeight)
    maskLayer.path = UIBezierPath(roundedRect: bounds,
                                  byRoundingCorners: [.topLeft, .topRight],
                                  cornerRadii: CGSize(width: 10, height: 10)).cgPath
  }

  private func commonInit() {
    backgroundColor = Constants.backgroundColor
    addStretchedToBounds(subview: titleLabel, insets: Constants.contentInset)
    layer.insertSublayer(bottomLineLayer, at: 0)
    layer.mask = maskLayer
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
