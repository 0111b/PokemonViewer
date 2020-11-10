//
//  XCTestCase+Snapshot.swift
//  PokemonViewerUITests
//
//  Created by Alexandr Goncharov on 10.11.2020.
//

import XCTest
import SnapshotTesting
import UIKit

extension UIView {

  func assertSnapshot(file: StaticString = #file,
                      testName: String = #function,
                      line: UInt = #line) {
    SnapshotTesting.assertSnapshot(matching: self.setLightStyle(), as: .image, named: "light",
                                   file: file, testName: testName, line: line)
    SnapshotTesting.assertSnapshot(matching: self.setDarkStyle(), as: .image, named: "dark",
                                   file: file, testName: testName, line: line)
  }

  @discardableResult
  func setDarkStyle() -> Self {
    if #available(iOS 13, *) {
      self.overrideUserInterfaceStyle = .dark
      self.backgroundColor = UIColor.systemBackground
    }
    return self
  }

  @discardableResult
  func setLightStyle() -> Self {
    if #available(iOS 13, *) {
      self.overrideUserInterfaceStyle = .light
      self.backgroundColor = UIColor.systemBackground
    }
    return self
  }

}

extension UIViewController {

  func assertSnapshot(file: StaticString = #file,
                      testName: String = #function,
                      line: UInt = #line) {

    let configs: [String: ViewImageConfig] = [
      "iPhoneXsMax.portrait.": .iPhoneXsMax(.portrait),
      "iPhoneXsMax.portrait.": .iPhoneXsMax(.landscape),
      "iPhone8Plus.portrait": .iPhone8Plus(.portrait),
      "iPhone8Plus.landscape": .iPhone8Plus(.landscape),
      "iPhoneX.portrait": .iPhoneX(.portrait),
      "iPhoneX.landscape": .iPhoneX(.landscape),
      "iPadPro12_9.portrait": .iPadPro12_9(.portrait),
      "iPadPro12_9.landscape": .iPadPro12_9(.landscape)
    ]

    func assert(_ viewController: UIViewController, label: String) {
      configs.forEach { deviceName, config in
        SnapshotTesting.assertSnapshot(matching: viewController, as: .image(on: config), named: deviceName + label,
                                       file: file, testName: testName, line: line)
      }
    }

    assert(self.setLightStyle(), label: "light")
    assert(self.setDarkStyle(), label: "dark")
  }

  @discardableResult
  func setDarkStyle() -> Self {
    if #available(iOS 13, *) {
      self.overrideUserInterfaceStyle = .dark
    }
    return self
  }

  @discardableResult
  func setLightStyle() -> Self {
    if #available(iOS 13, *) {
      self.overrideUserInterfaceStyle = .light
    }
    return self
  }

}
