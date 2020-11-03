//
//  TitledValueView.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import UIKit

final class TitledValueView: UIView {

  struct Style {
    let titleColor: UIColor
    let titleFont: UIFont
    let valueColor: UIColor
    let valueFont: UIFont
  }

  convenience init(style: Style) {
    self.init(frame: .zero)
    apply(style: style)
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
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(valueLabel)
  }

  func set(title: String, value: String?) {
    titleLabel.text = title
    valueLabel.text = value
  }

  func apply(style: Style) {
    titleLabel.textColor = style.titleColor
    titleLabel.font = style.titleFont
    valueLabel.textColor = style.valueColor
    valueLabel.font = style.valueFont
  }

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.alignment = .center
    stackView.spacing = 12
    return stackView
  }()


  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.setContentHuggingPriority(.required, for: .horizontal)
    label.textAlignment = .left
    return label
  }()

  private lazy var valueLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    label.textAlignment = .right
    return label
  }()
}
