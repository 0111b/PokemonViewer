//
//  NSMutableAttributedString+Higlight.swift
//  PokemonViewer
//
//  Created by Alexandr Goncharov on 09.11.2020.
//

import UIKit


extension NSMutableAttributedString {
  func highlight(substring: String, with color: UIColor) {
    let rawString = self.string
    guard let range = rawString.range(of: substring) else { return }
    addAttribute(.foregroundColor, value: color, range: NSRange(range, in: rawString))
  }
}
