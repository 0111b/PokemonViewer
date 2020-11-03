//
//  PokemonListViewController.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit

final class PokemonListViewController: UIViewController {

  @available(*, unavailable, message: "Use `init(viewModel:)` instead")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(viewModel: PokemonListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    view = collectionView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bind()
    viewModel.viewDidLoad()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateItemSize(for: state.layout)
  }

  private func setupUI() {
    title = Strings.Screens.PokemonList.title
    collectionView.backgroundColor = Constants.backgroundColor
    collectionView.register(PokemonListItemCell.self)
    collectionView.registerFooter(LoadingCollectionViewFooter.self)
    collectionView.refreshControl = refreshControl
    collectionView.dataSource = self
    collectionView.delegate = self
  }

  private func updateItemSize(for layout: PokemonListLayout) {
    let contentWidth = collectionView.bounds.width
    let proposedSize: CGSize
    switch layout {
    case .list:
      proposedSize = CGSize(width: contentWidth, height: Constants.listLayoutItemHeight)
    case .grid:
      let spacing = collectionViewLayout.minimumInteritemSpacing * CGFloat(Constants.itemsPerRow + 2)
      let side = max(Constants.girLayoutMinSide, (contentWidth - spacing) / CGFloat(Constants.itemsPerRow))
      proposedSize = CGSize(width: side, height: side)
    }
    let currentSize = collectionViewLayout.itemSize
    let shouldUpdate = abs(currentSize.width - proposedSize.width) > Constants.layoutUpdateTreshold
      || abs(currentSize.height - proposedSize.height) > Constants.layoutUpdateTreshold
    if shouldUpdate {
      let visibleIndexPaths = collectionView.indexPathsForVisibleItems
      collectionViewLayout.itemSize = proposedSize
      collectionViewLayout.footerReferenceSize = CGSize(width: contentWidth, height: Constants.footerHeight)
      collectionView.reloadItems(at: visibleIndexPaths)
    }
  }

  private func bind() {
    stateUpdateToken = viewModel.viewState.observe(on: .main) { [weak self] in
      self?.didUpdate(state: $0)
    }
  }

  private func didUpdate(state: PokemonListViewState) {
    refreshControl.endRefreshing()
    if self.state.layout != state.layout {
      updateItemSize(for: state.layout)
    }
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: state.layout.toggle().icon,
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(toggleLayout))
//    if #available(iOS 13, *) {
//      var deletes = [IndexPath]()
//      var inserts = [IndexPath]()
//      var moves = [(from:IndexPath, to:IndexPath)]()
//      let difference = state.items.difference(from: self.state.items)
//      for update in difference.inferringMoves() {
//        switch update {
//        case let .remove(offset: offset, element: _, associatedWith: move):
//          if let move = move {
//            moves.append((
//              from: IndexPath(item: offset, section: 0),
//              to: IndexPath(item: move, section: 0)
//            ))
//          } else {
//            deletes.append(IndexPath(item: offset, section: 0))
//          }
//        case let .insert(offset: offset, element: _, associatedWith: move):
//          if move == nil {
//            inserts.append(IndexPath(item: offset, section: 0))
//          }
//        }
//      }
//      collectionView.performBatchUpdates({
//        self.state = state
//        collectionView.deleteItems(at: deletes)
//        collectionView.insertItems(at: inserts)
//        moves.forEach { move in
//          collectionView.moveItem(at: move.from, to: move.to)
//        }
//      }, completion: nil)
//    } else {
      self.state = state
      collectionView.reloadData()
//    }
  }

  @objc private func toggleLayout() {
    viewModel.toggleLayout()
  }

  @objc private func didPullToRefresh() {
    viewModel.refresh()
  }

  private lazy var refreshControl: UIRefreshControl = {
    let control = UIRefreshControl()
    control.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    control.tintColor = Colors.accent
    return control
  }()

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.alwaysBounceVertical = true
    return collectionView
  }()

  private func itemViewModel(at indexPath: IndexPath) -> PokemonListItemViewModel? {
    let index = indexPath.row
    return state.items.indices.contains(index) ? state.items[index] : nil
  }

  private lazy var collectionViewLayout = UICollectionViewFlowLayout()

  private var state: PokemonListViewState = .empty

  private let viewModel: PokemonListViewModel
  private var stateUpdateToken: Disposable?

  private enum Constants {
    static let backgroundColor = Colors.background
    static let itemsPerRow = 4
    static let girLayoutMinSide: CGFloat = 150
    static let listLayoutItemHeight: CGFloat = 80
    static let layoutUpdateTreshold: CGFloat = 10
    static let footerHeight: CGFloat = 60
    static let itemStyle = PokemonListItemView.Style(titleColor: Colors.primaryText,
                                                     titleFont: Fonts.title,
                                                     backgroundColor: Colors.sectionBackground)
    static let selectedItemStyle = PokemonListItemView.Style(titleColor: Colors.primaryText,
                                                             titleFont: Fonts.title,
                                                             backgroundColor: .red)
  }
}

extension PokemonListViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return state.items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: PokemonListItemCell = collectionView.dequeue(forIndexPath: indexPath)
    cell.view.apply(style: cell.isSelected ? Constants.selectedItemStyle : Constants.itemStyle)
    if let viewModel = itemViewModel(at: indexPath) {
      cell.view.set(title: viewModel.title, image: viewModel.image, axis: state.layout.itemAxis)
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
    footer.update(with: state.loading)
    footer.tapHandler = { [weak self] in
      self?.viewModel.retry()
    }
    return footer
  }

}

extension PokemonListViewController: UICollectionViewDelegate {
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
    if indexPath.row > state.items.count - 4 {
      viewModel.askForNextPage()
    }
  }

  func collectionView(_ collectionView: UICollectionView,
                      didEndDisplaying cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {
    itemViewModel(at: indexPath)?.didEndDisplaying()
  }
}

private extension PokemonListLayout {
  var icon: UIImage? {
    switch self {
    case .grid: return Images.gridIcon
    case .list: return Images.listIcon
    }
  }

  var itemAxis: NSLayoutConstraint.Axis {
    switch self {
    case .grid: return .vertical
    case .list: return .horizontal
    }
  }
}
