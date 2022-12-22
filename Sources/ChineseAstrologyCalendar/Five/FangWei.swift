//
//  File.swift
//
//
//  Created by Xiangyu Sun on 12/10/22.
//

import Foundation

public enum FangWei {
  case dong
  case nan
  case xi
  case bei
  case zhong

  // MARK: Public

  public var chineseCharactor: String {
    switch self {
    case .dong:
      return "東"
    case .nan:
      return "南"
    case .xi:
      return "西"
    case .bei:
      return "北"
    case .zhong:
      return "中"
    }
  }
}
