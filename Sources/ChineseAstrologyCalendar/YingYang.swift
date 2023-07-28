//
//  File.swift
//
//
//  Created by Xiangyu Sun on 9/12/22.
//

import Foundation

// MARK: - YinYangIdentifiable

public protocol YinYangIdentifiable {
  var yin: Bool { get }
}

extension YinYangIdentifiable where Self: RawRepresentable, RawValue == Int {
  public var yin: Bool {
    rawValue.isMultiple(of: 2)
  }
}
