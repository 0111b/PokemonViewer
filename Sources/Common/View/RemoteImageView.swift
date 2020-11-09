//
//  RemoteImageView.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 07.11.2020.
//

import UIKit

enum RemoteImageViewState {
  case image(UIImage?)
  case loading

  static let empty: RemoteImageViewState = .image(nil)
}

final class RemoteImageView: UIImageView, Resetable {

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  override var image: UIImage? {
    get { super.image }
    set { set(state: .image(newValue)) }
  }

  func bind(to source: Observable<RemoteImageViewState>, on queue: DispatchQueue? = .main) {
    subscription = source.observe(on: queue) { [weak self] state in
      self?.set(state: state)
    }
  }

  func resetToEmptyState() {
    subscription = nil
    set(state: .empty)
  }

  func set(state: RemoteImageViewState) {
    switch state {
    case .image(let stateImage):
      activityIndicator.isHidden = true
      super.image = stateImage
    case .loading:
      activityIndicator.isHidden = false
      activityIndicator.startAnimating()
    }
  }

  override var tintColor: UIColor! {
    didSet { activityIndicator.color = tintColor }
  }

  private func commonInit() {
    addSubview(activityIndicator)
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

  private lazy var activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .gray)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.hidesWhenStopped = true
    return indicator
  }()

  private var subscription: Disposable?
}
