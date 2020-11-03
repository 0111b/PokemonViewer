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
    scrollView.addSubview(mainStackView)
    NSLayoutConstraint.activate([
      mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      mainStackView.leadingAnchor.constraint(equalTo: scrollView.readableContentGuide.leadingAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: scrollView.readableContentGuide.trailingAnchor),
      mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
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
    guard let pokemon = state.pokemon else { return }
    Swift.print(pokemon)
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
    return stackView
  }()


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
    static let backgroundColor = Colors.background
  }
}
