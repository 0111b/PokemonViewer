//
//  UICollectionView+Reusable.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit

public protocol Reusable {
  static var reuseIdentifier: String { get }
}

extension Reusable {
  /// Default implementation of reuseIndentifier is to use the class name,
  public static var reuseIdentifier: String {
    String(describing: self)
  }
}

/// Defines something that can be registered with a collection view, using the reuseIdentifer
public protocol CollectionViewRegisterable: Reusable {}

public protocol CollectionViewHeader: CollectionViewRegisterable {}

public protocol CollectionViewFooter: CollectionViewRegisterable {}

// MARK: - Dequeue
extension UICollectionView {

  // Cells
  public func dequeue<Cell>(forIndexPath indexPath: IndexPath) -> Cell
  where Cell: UICollectionViewCell & CollectionViewRegisterable {
    guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier,
                                         for: indexPath) as? Cell else {
      fatalError("Could not dequeue cell with identifier \(Cell.reuseIdentifier)")
    }
    return cell
  }

  // Header & Footer
  public func dequeueHeader<Header>(forIndexPath indexPath: IndexPath) -> Header
  where Header: UICollectionReusableView & CollectionViewHeader {
    dequeueSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, forIndexPath: indexPath)
  }

  public func dequeueFooter<Footer>(forIndexPath indexPath: IndexPath) -> Footer
  where Footer: UICollectionReusableView & CollectionViewFooter {
    dequeueSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, forIndexPath: indexPath)
  }

  private func dequeueSupplementaryView<View>(ofKind kind: String, forIndexPath indexPath: IndexPath) -> View
  where View: UICollectionReusableView & CollectionViewRegisterable {
    guard let cell = dequeueReusableSupplementaryView(ofKind: kind,
                                                      withReuseIdentifier: View.reuseIdentifier,
                                                      for: indexPath) as? View else {
      fatalError("Could not dequeue supplementary with identifier \(View.reuseIdentifier)")
    }
    return cell
  }
}

// MARK: - Register
extension UICollectionView {

  // Cells
  public func register<Cell: UICollectionViewCell>(_: Cell.Type) where Cell: CollectionViewRegisterable {
    register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
  }

  // Header & Footer
  public func registerHeader<Header: UICollectionReusableView>(_: Header.Type) where Header: CollectionViewHeader {
    registerSupplementaryView(Header.self, ofKind: UICollectionView.elementKindSectionHeader)
  }

  public func registerFooter<Footer: UICollectionReusableView>(_: Footer.Type) where Footer: CollectionViewFooter {
    registerSupplementaryView(Footer.self, ofKind: UICollectionView.elementKindSectionFooter)
  }

  private func registerSupplementaryView<T>(_: T.Type, ofKind kind: String)
  where T: UICollectionReusableView & CollectionViewRegisterable {
    register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
  }
}
