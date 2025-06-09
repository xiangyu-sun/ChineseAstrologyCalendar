//
//  Tiangan.swift
//
//
//  Created by 孙翔宇 on 25/03/2020.
//

import Foundation

/// The ten Heavenly Stems used in the traditional calendar.
public enum Tiangan: Int, CaseIterable, YinYangIdentifiable {
  case jia = 1, yi, bing, ding, wu, ji, geng, xin, ren, kui

  // MARK: Public

  /// Chinese character representation of the stem.
  public var chineseCharactor: String {
    switch self {
    case .jia:
      return "甲"
    case .yi:
      return "乙"
    case .bing:
      return "丙"
    case .ding:
      return "丁"
    case .wu:
      return "戊"
    case .ji:
      return "己"
    case .geng:
      return "庚"
    case .xin:
      return "辛"
    case .ren:
      return "壬"
    case .kui:
      return "癸"
    }
  }
}
