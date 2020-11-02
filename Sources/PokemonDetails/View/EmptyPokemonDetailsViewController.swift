//
//  EmptyPokemonDetailsViewController.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 02.11.2020.
//

import UIKit

final class EmptyPokemonDetailsViewController: UIViewController {

  @available(*, unavailable, message: "Use `init(viewModel:)` instead")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(viewModel: EmptyPokemonDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Constants.backgroundColor
    view.addSubview(hintMessageLabel)
    NSLayoutConstraint.activate([
      hintMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
      hintMessageLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
      hintMessageLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor)
    ])
    hintMessageLabel.text = viewModel.hintMessage
  }

  private lazy var hintMessageLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.adjustsFontForContentSizeCategory = true
    label.textColor = Constants.hintColor
    label.font = Constants.hintFont
    label.textAlignment = .center
    return label
  }()

  private let viewModel: EmptyPokemonDetailsViewModel

  private enum Constants {
    static let backgroundColor = Colors.background
    static let hintColor = Colors.primaryText
    static let hintFont = Fonts.title
  }

}
