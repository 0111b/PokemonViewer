//
//  SceneDelegate.swift
//  PockemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit

@available(iOS 13.0, *)
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  private var appCoordinator: AppCoordinator?

  var window: UIWindow?

  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      appCoordinator = AppCoordinator(window: window)
      appCoordinator?.start()
      window.makeKeyAndVisible()
      self.window = window
    }
  }

}
