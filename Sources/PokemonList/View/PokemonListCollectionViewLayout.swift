//
//  PokemonListCollectionViewLayout.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 04.11.2020.
//

import UIKit
import os.log

final class PokemonListCollectionViewLayout: UICollectionViewFlowLayout {

  var layout: PokemonListLayout = .list {
    didSet {
      if layout != oldValue { invalidateLayout() }
    }
  }

  override func prepare() {
    super.prepare()
    guard let collectionView = self.collectionView else { return }
    minimumInteritemSpacing = 5
    sectionInset = UIEdgeInsets(top: minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
    sectionInsetReference = .fromSafeArea
    let availableWidth = collectionView.bounds
      .inset(by: collectionView.contentInset)
      .inset(by: sectionInset)
      .width
    switch layout {
    case .grid:
      let spacing = minimumInteritemSpacing * CGFloat(Constants.gridMaxItemsPerRow)
      let maxSide = (availableWidth - spacing) / CGFloat(Constants.gridMaxItemsPerRow)
      let side = max(maxSide, Constants.girMinWidth)
      itemSize = CGSize(width: side, height: side + Constants.girHeightDelta)
    case .list:
      itemSize = CGSize(width: availableWidth, height: Constants.listLayoutItemHeight)
    }
    footerReferenceSize = CGSize(width: availableWidth, height: Constants.footerHeight)
  }

  private enum Constants {
    static let listLayoutItemHeight: CGFloat = 80
    static let gridMaxItemsPerRow = 4
    static let girMinWidth: CGFloat = 100
    static let girHeightDelta: CGFloat = 20
    static let footerHeight: CGFloat = 60
  }
}
