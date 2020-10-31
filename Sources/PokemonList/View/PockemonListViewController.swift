//
//  PokemonListViewController.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit

final class PokemonListViewController: UIViewController {

  @available(*, unavailable, message: "Use `init(viewModel:)` instead")
  required init?(coder: NSCoder) {64
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
    collectionView.backgroundColor = Constants.backgroundColor
    collectionView.register(PokemonListItemCell.self)
    collectionView.dataSource = self
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
    stateUpdateToken = viewModel.viewState.observe(on: .main) { [unowned self] in
      self.didUpdate(state: $0)
    }
  }

  private func didUpdate(state: PokemonListViewState) {
    collectionView.reloadData()
  }

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  private lazy var collectionViewLayout = UICollectionViewFlowLayout()

  private let viewModel: PokemonListViewModel
  private var stateUpdateToken: Disposable?
}

extension PokemonListViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 500
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: PokemonListItemCell = collectionView.dequeue(forIndexPath: indexPath)
    cell.view.apply(style: Constants.itemStyle)
    cell.view.show()
    return cell
  }

  private enum Constants {
    static let backgroundColor = Colors.backgroundColor
    static let itemsPerRow = 4
    static let minItemWidth: CGFloat = 100
    static let lineItemHeight: CGFloat = 80

    static let itemStyle = PokemonListItemView.Style(titleColor: Colors.primaryColor,
                                                     titleFont: Fonts.caption,
                                                     backgroundColor: Colors.sectionBackground)
  }
}
