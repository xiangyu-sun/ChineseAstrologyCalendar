//
//  File.swift
//
//
//  Created by 孙翔宇 on 04/07/2020.
//

import Foundation

// MARK: - Ganzhi

public struct Ganzhi: CustomStringConvertible, Equatable, YinYangIdentifiable, Hashable {
  public var yin: Bool {
    gan.yin && zhi.yin
  }

  let gan: Tiangan
  let zhi: Dizhi

  public var description: String {
    gan.chineseCharactor + zhi.chineseCharactor
  }
}

extension Ganzhi {
  public var formatedYear: String {
    description + "年"
  }

  public var formatedMonth: String {
    description + "月"
  }
}
