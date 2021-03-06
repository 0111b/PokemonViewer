//
//  SpritesView.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 03.11.2020.
//

import UIKit

final class SpritesView: UIView {

  func set(sprites: [PokemonSpriteViewModel]) {
    items = sprites
    collectionView.reloadData()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private var items = [PokemonSpriteViewModel]()

  private func commonInit() {
    backgroundColor = Colors.background
    translatesAutoresizingMaskIntoConstraints = false
    addStretchedToBounds(subview: collectionView)
    collectionView.heightAnchor.constraint(equalToConstant: Constants.itemSize).isActive = true
    collectionView.register(SpritesItemCell.self)
    collectionView.dataSource = self
  }

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: Constants.itemSize, height: Constants.itemSize)
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.alwaysBounceHorizontal = true
    collectionView.backgroundColor = Colors.background
    return collectionView
  }()

  private enum Constants {
    static let itemSize: CGFloat = 200
    static let itemStyle = SpritesItemView.Style(titleColor: Colors.primaryText,
                                                        titleFont: Fonts.title,
                                                        backgroundColor: Colors.sectionBackground)
  }
}

extension SpritesView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: SpritesItemCell = collectionView.dequeue(forIndexPath: indexPath)
    cell.view.apply(style: Constants.itemStyle)
    let viewModel = items[indexPath.row]
    cell.view.set(title: viewModel.kind.legend,
                  image: viewModel.image)
    viewModel.fetchImage()
    return cell
  }
}
