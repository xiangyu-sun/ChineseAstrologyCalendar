//
//  Tiangan.swift
//
//
//  Created by 孙翔宇 on 25/03/2020.
//

import Foundation

/// The ten Heavenly Stems used in the traditional calendar.
public enum Tiangan: Int, CaseIterable, YinYangIdentifiable, FangWeiConvertible, TraditionalChineseNaming, Sendable {
  case jia = 1, yi, bing, ding, wu, ji, geng, xin, ren, kui

  // MARK: Public
  
  
  // MARK: - Five Elements (Wuxing) Mapping

  /// Converts a Heavenly Stem to its corresponding Five Element (Wuxing).
  public var wuxing: Wuxing {
    // rawValue 1–10 maps in pairs to Wuxing rawValue 0–4: (rawValue-1)/2
    return Wuxing(rawValue: (self.rawValue - 1) / 2) ?? .earth
  }

  /// Cardinal direction associated with this stem via its ``Wuxing`` element.
  public var fangwei: FangWei { wuxing.fangwei }
  

  /// Traditional Chinese character for this stem.
  public var traditionalChineseName: String { chineseCharacter }

  /// Chinese character representation of the stem.
  public var chineseCharacter: String {
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

  /// Chinese character representation of the stem.
  @available(*, deprecated, renamed: "chineseCharacter", message: "Use chineseCharacter instead (spelling corrected)")
  public var chineseCharactor: String {
    chineseCharacter
  }

  /// Hanyu Pinyin romanization of the stem, with tone marks.
  public var pinyin: String {
    switch self {
    case .jia:  return "jiǎ"
    case .yi:   return "yǐ"
    case .bing: return "bǐng"
    case .ding: return "dīng"
    case .wu:   return "wù"
    case .ji:   return "jǐ"
    case .geng: return "gēng"
    case .xin:  return "xīn"
    case .ren:  return "rén"
    case .kui:  return "guǐ"
    }
  }
}
