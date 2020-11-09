//
//  UICollectionViewContainerCell.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit

open class UICollectionViewContainerCell<Content>: UICollectionViewCell, CollectionViewRegisterable
where Content: UIView {

  public let view: Content

  public var contentViewInsets = UIEdgeInsets.zero {
    didSet { contentConstraints.updateWith(contentViewInsets) }
  }

  private let contentConstraints = ContainerContentConstraints()

  /// Do not call super when overriding this method
  open class func makeViewInstanse() -> Content {
    Content()
  }

  public override init(frame: CGRect) {
    view = type(of: self).makeViewInstanse()
    super.init(frame: frame)
    _initialSetup()
  }

  public required init?(coder aDecoder: NSCoder) {
    view = type(of: self).makeViewInstanse()
    super.init(coder: aDecoder)
    _initialSetup()
  }

  open override func prepareForReuse() {
    super.prepareForReuse()
    if let resetable = view as? Resetable {
      resetable.resetToEmptyState()
    }
  }

  open override var isHighlighted: Bool {
    didSet {
      if let highlightable = view as? Highlightable {
        highlightable.set(highlighted: isHighlighted)
      }
    }
  }

  /// Override this method in subClasses for setup during init() time. It's not necessary to call super when overriding
  open func initialSetup() {}

  private func _initialSetup() {
    installView()
    initialSetup()
  }

  private func installView() {
    view.translatesAutoresizingMaskIntoConstraints = false
    let superView: UIView = contentView
    superView.addSubview(view)

    let leading = view.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: contentViewInsets.left)
    let trailing = superView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: contentViewInsets.right)
    let top = view.topAnchor.constraint(equalTo: superView.topAnchor, constant: contentViewInsets.top)
    let bottom = superView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: contentViewInsets.bottom)

    NSLayoutConstraint.activate([leading, trailing, top, bottom])

    contentConstraints.leading = leading
    contentConstraints.trailing = trailing
    contentConstraints.top = top
    contentConstraints.bottom = bottom
  }
}

private final class ContainerContentConstraints {
  public weak var top: NSLayoutConstraint?
  public weak var bottom: NSLayoutConstraint?
  public weak var leading: NSLayoutConstraint?
  public weak var trailing: NSLayoutConstraint?

  public init() {}

  public func updateWith(_ insets: UIEdgeInsets) {
    top?.constant = insets.top
    bottom?.constant = insets.bottom
    leading?.constant = insets.left
    trailing?.constant = insets.right
  }
}
