//
//  PokemonDetailsViewController.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import UIKit
import UITeststingSupport

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
    view.accessibilityIdentifier = AccessibilityId.PokemonDetails.screen
    title = viewModel.identifier.rawValue.capitalized
    view.addSubview(scrollView)
    scrollView.addStretchedToBounds(subview: contentContainerView)
    contentContainerView.addSubview(mainStackView)
    let readableGuide = contentContainerView.readableContentGuide
    mainStackView.addArrangedSubviews([
      heightView,
      weightView,
      spritesHeaderView,
      spritesView,
      makeHeader(title: Strings.Screens.PokemonDetails.Header.stats),
      statsStackView,
      makeHeader(title: Strings.Screens.PokemonDetails.Header.abilities),
      abilitiesLabel,
      makeHeader(title: Strings.Screens.PokemonDetails.Header.types),
      typesLabel
    ])
    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      scrollView.widthAnchor.constraint(equalTo: contentContainerView.widthAnchor),
      mainStackView.leadingAnchor.constraint(equalTo: readableGuide.leadingAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: readableGuide.trailingAnchor),
      mainStackView.topAnchor.constraint(equalTo: readableGuide.topAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: readableGuide.bottomAnchor)
    ])
    view.addStretchedToBounds(subview: loadingView)
    view.addStretchedToBounds(subview: errorView)
    didUpdate(state: .idle)
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
    spritesView.set(sprites: details.sprites)
    let isSpritesHidden = details.sprites.isEmpty
    spritesHeaderView.isHidden = isSpritesHidden
    spritesView.isHidden = isSpritesHidden
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
    view.set(title: Strings.Screens.PokemonDetails.Content.statTitleFormat(name: stat.kind.name,
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

  private lazy var contentContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Colors.background
    view.directionalLayoutMargins = Constants.contentInset
    return view
  }()

  private lazy var mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.accessibilityIdentifier = AccessibilityId.PokemonDetails.contentView
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .fill
    stackView.spacing = Constants.contentSpacing
    stackView.isLayoutMarginsRelativeArrangement = true
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

  private lazy var heightView = TitledValueView(style: Constants.titledValueStyle)

  private lazy var weightView = TitledValueView(style: Constants.titledValueStyle)

  private lazy var spritesHeaderView = makeHeader(title: Strings.Screens.PokemonDetails.Header.sprites)

  private lazy var spritesView = SpritesView()

  private lazy var abilitiesLabel = makeContentLabel()

  private lazy var typesLabel = makeContentLabel()

  private lazy var loadingView = PokemonDetailLoadingView()

  private lazy var errorView: PokemonDetailErrorView = {
    let errorView = PokemonDetailErrorView()
    errorView.accessibilityIdentifier = AccessibilityId.PokemonDetails.errorView
    errorView.action = { [weak self] in
      self?.viewModel.retry()
    }
    return errorView
  }()

  private let viewModel: PokemonDetailsViewModel
  private var stateUpdateToken: Disposable?

  private enum Constants {
    static let contentInset = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
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

private extension PokemonStat.Kind {
  var name: String {
    switch self {
    case .custom(let string): return string.capitalized
    case .health: return Strings.Screens.PokemonDetails.Content.health
    case .attack: return Strings.Screens.PokemonDetails.Content.attack
    case .defense: return Strings.Screens.PokemonDetails.Content.defense
    case .specialAttack: return Strings.Screens.PokemonDetails.Content.specialAttack
    case .specialDefense: return Strings.Screens.PokemonDetails.Content.specialDefense
    case .speed: return Strings.Screens.PokemonDetails.Content.speed
    }
  }
}
