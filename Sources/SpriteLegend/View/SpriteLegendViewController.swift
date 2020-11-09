//
//  SpriteLegendViewController.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 09.11.2020.
//

import UIKit
import UITeststingSupport

final class SpriteLegendViewController: UIViewController {

  typealias SpriteLegendCell = UICollectionViewContainerCell<TitledValueView>

  @available(*, unavailable, message: "Use `init(viewModel:)` instead")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(viewModel: SpriteLegendViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Constants.backgroundColor
    view.accessibilityIdentifier = AccessibilityId.SpriteLegend.screen
    collectionView.backgroundColor = Constants.backgroundColor
    view.tintColor = Constants.tintColor
    title = viewModel.title
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
      collectionView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor)
    ])
    collectionView.register(SpriteLegendCell.self)
    collectionView.dataSource = self
    collectionView.reloadData()
  }

  private lazy var collectionLayout = PokemonListCollectionViewLayout()

  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)

  private let viewModel: SpriteLegendViewModel

  private enum Constants {
    static let tintColor = Colors.accent
    static let backgroundColor = Colors.background
    static let itemStyle = TitledValueView.Style(titleColor: Colors.primaryText,
                                                 titleFont: Fonts.header,
                                                 valueColor: Colors.secondaryText,
                                                 valueFont: Fonts.title)
    static let itemHeight: CGFloat = 50
  }
}

extension SpriteLegendViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.items.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = viewModel.items[indexPath.row]
    let cell: SpriteLegendCell = collectionView.dequeue(forIndexPath: indexPath)
    cell.view.apply(style: Constants.itemStyle)
    cell.view.set(title: item.title, value: item.value)
    return cell
  }

}
