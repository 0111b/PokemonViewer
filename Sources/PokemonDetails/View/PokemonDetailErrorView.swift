//
//  PokemonDetailErrorView.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import UIKit

final class PokemonDetailErrorView: UIView {

  var reason: String? {
    get { resonLabel.text }
    set { resonLabel.text = newValue }
  }

  var action: () -> Void = {}

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
    addSubview(resonLabel)
    addSubview(actionButton)
    NSLayoutConstraint.activate([
      resonLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      resonLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      resonLabel.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor),
      actionButton.topAnchor.constraint(equalToSystemSpacingBelow: resonLabel.bottomAnchor, multiplier: 1.0)
    ])
  }

  @objc private func didTapButton() {
    action()
  }

  private lazy var resonLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.adjustsFontForContentSizeCategory = true
    label.textColor = Colors.primaryText
    label.font = Fonts.title
    label.textAlignment = .center
    return label
  }()

  private lazy var actionButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.tintColor = Colors.accent
    button.setImage(Images.retryIcon, for: .normal)
    button.setTitleColor(Colors.accent, for: .normal)
    button.setTitle(Strings.Screens.PokemonDetails.Error.cta, for: .normal)
    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    return button
  }()

}
