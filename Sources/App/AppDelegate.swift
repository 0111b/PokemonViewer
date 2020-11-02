//
//  AppDelegate.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 31.10.2020.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow? = UIWindow()
  private var appCoordinator: AppCoordinator?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    if #available(iOS 13, *) { } else {
      let window = UIWindow()
      appCoordinator = AppCoordinator(window: window)
      appCoordinator?.start()
      window.makeKeyAndVisible()
      self.window = window
    }
    return true
  }

  // MARK: UISceneSession Lifecycle

  @available(iOS 13.0, *)
  func application(_ application: UIApplication,
                   configurationForConnecting connectingSceneSession: UISceneSession,
                   options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

}
