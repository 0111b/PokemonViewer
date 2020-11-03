//
//  PokemonDetailsViewController.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import UIKit

final class PokemonDetailsViewController: UIViewController {
  @available(*, unavailable, message: "Use `init(viewModel:)` instead")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(viewModel: PokemonDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bind()
    viewModel.viewDidLoad()
  }

  private func setupUI() {
    view.backgroundColor = Constants.backgroundColor
    title = viewModel.identifier.rawValue
    view.addStretchedToBounds(subview: scrollView)
    scrollView.addStretchedToBounds(subview: mainStackView, insets: Constants.contentInset)
    mainStackView.addArrangedSubviews([
      nameLabel,
      heightView,
      weightView,
      makeHeader(title: Strings.Screens.PokemonDetails.Header.sprites),
      makeHeader(title: Strings.Screens.PokemonDetails.Header.stats),
      statsStackView,
      makeHeader(title: Strings.Screens.PokemonDetails.Header.abilities),
      abilitiesLabel,
      makeHeader(title: Strings.Screens.PokemonDetails.Header.types),
      typesLabel
    ])
    NSLayoutConstraint.activate([
      scrollView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor,
                                        constant: Constants.contentInset.left + Constants.contentInset.right)
    ])
    view.addStretchedToBounds(subview: loadingView)
    view.addStretchedToBounds(subview: errorView)
  }

  private func bind() {
    stateUpdateToken = viewModel.pokemon.observe(on: .main) { [weak self] state in
      self?.didUpdate(state: state)
    }
  }

  private func didUpdate(state: PokemonDetailsViewState) {
    loadingView.isHidden = !state.isLoading
    if let error = state.error {
      errorView.reason = error
      errorView.isHidden = false
    } else {
      errorView.isHidden = true
    }
    guard let details = state.details else { return }
    let pokemon = details.pokemon
    nameLabel.text = pokemon.id.rawValue
    heightView.set(title: Strings.Screens.PokemonDetails.Content.height,
                   value: LengthFormatter.default.string(fromDecimetres: pokemon.height))
    weightView.set(title: Strings.Screens.PokemonDetails.Content.weight,
                   value: MassFormatter.default.string(fromHectograms: pokemon.height))
    abilitiesLabel.text = pokemon.abilities
      .map(\.id.rawValue)
      .joined(separator: Strings.Screens.PokemonDetails.Content.listSeparator)
    typesLabel.text = pokemon.types
      .map(\.id.rawValue)
      .joined(separator: Strings.Screens.PokemonDetails.Content.listSeparator)
    statsStackView.removeArrangedSubviews()
    statsStackView.addArrangedSubviews(pokemon.stats.map(makeStatView(from:)))
  }

  private func makeHeader(title: String) -> UIView {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    label.textAlignment = .left
    label.backgroundColor = Constants.headerBackgroundColor
    label.textColor = Constants.headerColor
    label.font = Constants.headerFont
    label.text = title
    return label
  }

  private func makeContentLabel() -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    label.textAlignment = .left
    label.numberOfLines = 0
    label.backgroundColor = Constants.backgroundColor
    label.textColor = Constants.primaryColor
    label.font = Constants.contentFont
    return label
  }

  private func makeStatView(from stat: PokemonStat) -> UIView {
    let view = TitledValueView(style: Constants.titledValueStyle)
    view.set(title: Strings.Screens.PokemonDetails.Content.statTitleFormat(name: stat.id.rawValue,
                                                                           level: stat.effort),
             value: String(stat.baseStat))
    return view
  }

  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.isScrollEnabled = true
    scrollView.isPagingEnabled = false
    scrollView.bounces = true
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = true
    return scrollView
  }()

  private lazy var mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .fill
    stackView.spacing = Constants.contentSpacing
    return stackView
  }()

  private lazy var statsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .fill
    stackView.spacing = Constants.contentSpacing
    return stackView
  }()

  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    label.textAlignment = .left
    label.textColor = Constants.primaryColor
    label.font = Constants.nameFont
    return label
  }()

  private lazy var heightView = TitledValueView(style: Constants.titledValueStyle)

  private lazy var weightView = TitledValueView(style: Constants.titledValueStyle)

  private lazy var abilitiesLabel = makeContentLabel()

  private lazy var typesLabel = makeContentLabel()

  private lazy var loadingView = PokemonDetailLoadingView()

  private lazy var errorView: PokemonDetailErrorView = {
    let errorView = PokemonDetailErrorView()
    errorView.action = { [weak self] in
      self?.viewModel.retry()
    }
    return errorView
  }()

  private let viewModel: PokemonDetailsViewModel
  private var stateUpdateToken: Disposable?

  private enum Constants {
    static let contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    static let contentSpacing: CGFloat = 12

    static let backgroundColor = Colors.background
    static let headerBackgroundColor = Colors.sectionBackground
    static let primaryColor = Colors.primaryText
    static let headerColor = Colors.secondaryText

    static let nameFont = Fonts.caption
    static let headerFont = Fonts.header
    static let contentFont = Fonts.title

    static var titledValueStyle: TitledValueView.Style {
      TitledValueView.Style(titleColor: Colors.primaryText,
                            titleFont: headerFont,
                            valueColor: Colors.secondaryText,
                            valueFont: contentFont)
    }
  }
}
