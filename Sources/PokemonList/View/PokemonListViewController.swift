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
    updateItemSize(contentSize: collectionView.bounds.size)
  }

  private func setupUI() {
    title = Strings.Screens.PokemonList.title
    collectionView.backgroundColor = Constants.backgroundColor
    collectionView.register(PokemonListItemCell.self)
    collectionView.dataSource = self
    collectionView.delegate = self
  }

  private func updateItemSize(contentSize: CGSize) {
    let itemSize: CGSize
    let spacing = collectionViewLayout.minimumInteritemSpacing * CGFloat(Constants.itemsPerRow + 2)
    let side = (contentSize.width - spacing) / CGFloat(Constants.itemsPerRow)
    if side < Constants.minItemWidth {
      itemSize = CGSize(width: contentSize.width, height: Constants.lineItemHeight)
    } else {
      itemSize = CGSize(width: side, height: side)
    }
    if collectionViewLayout.itemSize != itemSize {
      collectionViewLayout.itemSize = itemSize
    }
  }

  private func bind() {
    stateUpdateToken = viewModel.viewState.observe(on: .main) { [weak self] in
      self?.didUpdate(state: $0)
    }
  }

  private func didUpdate(state: PokemonListViewState) {
    updateCollectionView(state: state)
  }

  private func updateCollectionView(state: PokemonListViewState) {
    if #available(iOS 13, *) {
      var deletes = [IndexPath]()
      var inserts = [IndexPath]()
      var moves = [(from:IndexPath, to:IndexPath)]()
      let difference = state.items.difference(from: items)
      for update in difference.inferringMoves() {
        switch update {
        case let .remove(offset: offset, element: _, associatedWith: move):
          if let move = move {
            moves.append((
              from: IndexPath(item: offset, section: 0),
              to: IndexPath(item: move, section: 0)
            ))
          } else {
            deletes.append(IndexPath(item: offset, section: 0))
          }
        case let .insert(offset: offset, element: _, associatedWith: move):
          if move == nil {
            inserts.append(IndexPath(item: offset, section: 0))
          }
        }
      }
      collectionView.performBatchUpdates({
        items = items.applying(difference) ?? []
        collectionView.deleteItems(at: deletes)
        collectionView.insertItems(at: inserts)
        moves.forEach { move in
          collectionView.moveItem(at: move.from, to: move.to)
        }
      }, completion: nil)
    } else {
      items = state.items
      collectionView.reloadData()
    }
  }

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  private func itemViewModel(at indexPath: IndexPath) -> PokemonListItemViewModel {
    items[indexPath.row]
  }

  private lazy var collectionViewLayout = UICollectionViewFlowLayout()

  private var items = [PokemonListItemViewModel]()

  private let viewModel: PokemonListViewModel
  private var stateUpdateToken: Disposable?
}

extension PokemonListViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: PokemonListItemCell = collectionView.dequeue(forIndexPath: indexPath)
    let viewModel = itemViewModel(at: indexPath)
    cell.view.apply(style: Constants.itemStyle)
    cell.view.set(title: viewModel.title, image: viewModel.image)
    return cell
  }

  private enum Constants {
    static let backgroundColor = Colors.background
    static let itemsPerRow = 4
    static let minItemWidth: CGFloat = 100
    static let lineItemHeight: CGFloat = 80

    static let itemStyle = PokemonListItemView.Style(titleColor: Colors.accent,
                                                     titleFont: Fonts.title,
                                                     backgroundColor: Colors.sectionBackground)
  }
}

extension PokemonListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    viewModel.didSelect(item: itemViewModel(at: indexPath))
  }

  func collectionView(_ collectionView: UICollectionView,
                      willDisplay cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {
    itemViewModel(at: indexPath).willDisplay()
  }

  func collectionView(_ collectionView: UICollectionView,
                      didEndDisplaying cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {
    itemViewModel(at: indexPath).didEndDisplaying()
  }
}
