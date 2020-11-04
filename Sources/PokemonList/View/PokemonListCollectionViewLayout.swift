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
      updateItemSize()
    }
  }

  override func finalizeAnimatedBoundsChange() {
    super.finalizeAnimatedBoundsChange()
    updateItemSize()
  }

  private func updateItemSize() {
    guard let collectionView = self.collectionView else { return }
    let sectionPadding = sectionInset.left + sectionInset.right
    let contentPadding = collectionView.contentInset.left + collectionView.contentInset.right
    let contentWidth = collectionView.bounds.width - sectionPadding - contentPadding
    let proposedSize: CGSize
    switch layout {
    case .list:
      proposedSize = CGSize(width: contentWidth, height: Constants.listLayoutItemHeight)
    case .grid:
      let spacing = minimumInteritemSpacing * CGFloat(Constants.maxItemsPerRow + 2)
      let side = max(Constants.girLayoutMinSide,
                     (contentWidth - spacing) / CGFloat(Constants.maxItemsPerRow))
      proposedSize = CGSize(width: side, height: side)
    }
    let currentSize = self.itemSize
    let shouldUpdate = abs(currentSize.width - proposedSize.width) > Constants.layoutUpdateTreshold
      || abs(currentSize.height - proposedSize.height) > Constants.layoutUpdateTreshold
    if shouldUpdate {
      os_log("PokemonListCollectionViewLayout itemSize %@", log: Log.general,
             type: .debug, String(describing: proposedSize))
      itemSize = proposedSize
      footerReferenceSize = CGSize(width: contentWidth, height: Constants.footerHeight)
      collectionView.reloadData()
    }
  }

  private enum Constants {
    static let maxItemsPerRow = 4
    static let girLayoutMinSide: CGFloat = 150
    static let listLayoutItemHeight: CGFloat = 80
    static let layoutUpdateTreshold: CGFloat = 10
    static let footerHeight: CGFloat = 60
  }
}
