//
//  File.swift
//
//
//  Created by Xiangyu Sun on 12/10/22.
//

import Foundation

public enum Wuxing: Int, CaseIterable {

  case mu
  case huo
  case tu
  case jin
  case shui

  // MARK: Public

  public var tiangan: (Tiangan, Tiangan) {
    switch self {
    case .mu:
      return (.jia, .yi)
    case .huo:
      return (.bing, .ding)
    case .tu:
      return (.wu, .ji)
    case .jin:
      return (.geng, .xin)
    case .shui:
      return (.ren, .kui)
    }
  }

  public var chineseCharacter: String {
    switch self {
    case .jin:
      return "金"
    case .mu:
      return "木"
    case .shui:
      return "水"
    case .huo:
      return "火"
    case .tu:
      return "土"
    }
  }

  public var sheng: Wuxing {
    Wuxing(rawValue: rawValue.advanced(by: 1) % Wuxing.allCases.count) ?? .jin
  }

  public var ke: Wuxing {
    Wuxing(rawValue: rawValue.advanced(by: 2) % Wuxing.allCases.count) ?? .jin
  }

  public var dizhi: [Dizhi] {
    switch self {
    case .mu:
      return [.yin, .mao]
    case .huo:
      return [.wu, .si]
    case .tu:
      return [.chen, .wu, .chou, .wei]
    case .jin:
      return [.shen, .you]
    case .shui:
      return [.zi, .hai]
    }
  }

  public var fangwei: FangWei {
    switch self {
    case .jin:
      return .xi
    case .tu:
      return .zhong
    case .huo:
      return .nan
    case .mu:
      return .dong
    case .shui:
      return .bei
    }
  }

}