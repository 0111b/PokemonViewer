//
//  PokemonListViewController.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit
import UITeststingSupport

final class PokemonListViewController: UIViewController {

  @available(*, unavailable, message: "Use `init(viewModel:)` instead")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(viewModel: PokemonListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bind()
    viewModel.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    collectionView.indexPathsForSelectedItems?.forEach { indexPath in
      self.collectionView(collectionView, didDeselectItemAt: indexPath)
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    collectionViewLayout.layout = state.layout
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    let visibleIdentifiers = collectionView.indexPathsForVisibleItems
      .compactMap(itemViewModel(at:))
      .map(\.identifier)
    viewModel.didReceiveMemoryWarning(visibleIdentifiers: visibleIdentifiers)
  }

  // MARK: - Private -

  private func setupUI() {
    view.accessibilityIdentifier = AccessibilityId.PokemonList.screen
    view.backgroundColor = Constants.backgroundColor
    title = Strings.Screens.PokemonList.title
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
    collectionView.register(PokemonListItemCell.self)
    collectionView.registerFooter(LoadingCollectionViewFooter.self)
    collectionView.refreshControl = refreshControl
    collectionView.dataSource = self
    collectionView.delegate = self
    definesPresentationContext = true
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = searchController
  }

  private func bind() {
    stateUpdateToken = viewModel.viewState.observe(on: .main) { [weak self] in
      self?.didUpdate(state: $0)
    }
  }

  private func didUpdate(state: PokemonListViewState) {
    refreshControl.endRefreshing()
    navigationItem.leftBarButtonItem = makeLayoutSwitchButtonItem(for: state.layout)
    self.state = state
    collectionViewLayout.layout = state.layout

    // Improvement: gracefully update only changed item
    // Logic must be extracted to the separate generic datasource
    // NOTE: Collection.difference(from:) and UICollectionViewDiffableDataSource is available on iOS 13.
    collectionView.reloadData()
  }

  @objc private func toggleLayout() {
    viewModel.toggleLayout()
  }

  private func makeLayoutSwitchButtonItem(for layout: PokemonListLayout) -> UIBarButtonItem {
    let item = UIBarButtonItem(image: layout.toggle().icon,
                               style: .plain,
                               target: self,
                               action: #selector(toggleLayout))
    item.accessibilityIdentifier = layout.accessibilityIdentifier
    return item
  }

  @objc private func didPullToRefresh() {
    viewModel.refresh()
  }

  private lazy var refreshControl: UIRefreshControl = {
    let control = UIRefreshControl()
    control.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    control.tintColor = Constants.tintColor
    return control
  }()

  private lazy var collectionViewLayout = PokemonListCollectionViewLayout()

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    collectionView.accessibilityIdentifier = AccessibilityId.PokemonList.pokemonList
    collectionView.backgroundColor = Constants.backgroundColor
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.alwaysBounceVertical = true
    collectionView.contentInset = Constants.contentInset
    return collectionView
  }()

  private lazy var searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.delegate = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = Strings.Screens.PokemonList.Search.placeholder
    searchController.searchBar.tintColor = Constants.tintColor
    return searchController
  }()

  private var updateSearchQeury: DispatchWorkItem?

  private func itemViewModel(at indexPath: IndexPath) -> PokemonListItemViewModel? {
    let index = indexPath.row
    return state.items.indices.contains(index) ? state.items[index] : nil
  }

  private var state: PokemonListViewState = .empty

  private let viewModel: PokemonListViewModel
  private var stateUpdateToken: Disposable?

  private enum Constants {
    static let backgroundColor = Colors.background
    static let tintColor = Colors.accent
    static let itemStyle = PokemonListItemView.Style(titleColor: Colors.primaryText,
                                                     titleFont: Fonts.title,
                                                     backgroundColor: Colors.sectionBackground)
    static let selectedItemStyle = PokemonListItemView.Style(titleColor: Colors.primaryText,
                                                             titleFont: Fonts.title,
                                                             backgroundColor: Colors.accent)
    static let contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
  }
}

// MARK: - UICollectionViewDataSource -
extension PokemonListViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return state.items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: PokemonListItemCell = collectionView.dequeue(forIndexPath: indexPath)
    cell.accessibilityIdentifier = AccessibilityId.PokemonList.pokemon(at: indexPath.row)
    cell.view.apply(style: cell.isSelected ? Constants.selectedItemStyle : Constants.itemStyle)
    if let viewModel = itemViewModel(at: indexPath) {
      cell.view.set(state: viewModel.viewState, layout: state.layout)
    } else {
      cell.view.resetToEmptyState()
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionFooter else {
      return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                             withReuseIdentifier: "Footer",
                                                             for: indexPath)
    }
    let footer: LoadingCollectionViewFooter = collectionView.dequeueFooter(forIndexPath: indexPath)
    footer.accessibilityIdentifier = AccessibilityId.PokemonList.statusView
    footer.update(with: state.loading)
    footer.tapHandler = { [weak self] in
      self?.viewModel.retry()
    }
    return footer
  }

}

// MARK: - UICollectionViewDelegate -
extension PokemonListViewController: UICollectionViewDelegate, UIScrollViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    itemViewModel(at: indexPath).map(viewModel.didSelect(item:))
    if let cell = collectionView.cellForItem(at: indexPath) as? PokemonListItemCell {
      cell.view.apply(style: Constants.selectedItemStyle)
    }
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? PokemonListItemCell {
      cell.view.apply(style: Constants.itemStyle)
    }
  }

  func collectionView(_ collectionView: UICollectionView,
                      willDisplay cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {
    itemViewModel(at: indexPath)?.willDisplay()
  }

  func collectionView(_ collectionView: UICollectionView,
                      didEndDisplaying cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {
    itemViewModel(at: indexPath)?.didEndDisplaying()
  }

  func collectionView(_ collectionView: UICollectionView,
                      willDisplaySupplementaryView view: UICollectionReusableView,
                      forElementKind elementKind: String,
                      at indexPath: IndexPath) {
    guard view is LoadingCollectionViewFooter else { return }
    viewModel.askForNextPage()
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    searchController.searchBar.endEditing(true)
  }
}

// MARK: - UISearchControllerDelegate -
extension PokemonListViewController: UISearchControllerDelegate {
  func willPresentSearchController(_ searchController: UISearchController) {
    collectionView.setContentOffset(CGPoint(x: -Constants.contentInset.left, y: -Constants.contentInset.right),
                                    animated: true)
  }

  func willDismissSearchController(_ searchController: UISearchController) {
    collectionView.setContentOffset(CGPoint(x: -Constants.contentInset.left, y: -Constants.contentInset.right),
                                    animated: true)
  }
}

// MARK: - UISearchResultsUpdating -
extension PokemonListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text?
            .trimmingCharacters(in: .whitespacesAndNewlines)
    else { return }
    updateSearchQeury?.cancel()
    let task = DispatchWorkItem { [weak self] in
      self?.viewModel.didChangeNameFilter(name: searchText)
    }
    updateSearchQeury = task
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
  }
}

// MARK: - Extensions -

private extension PokemonListLayout {
  var icon: UIImage? {
    switch self {
    case .grid: return Images.gridIcon
    case .list: return Images.listIcon
    }
  }

  var accessibilityIdentifier: String {
    switch self {
    case .grid: return AccessibilityId.PokemonList.gridLayoutButton
    case .list: return AccessibilityId.PokemonList.listLayoutButton
    }
  }
}
