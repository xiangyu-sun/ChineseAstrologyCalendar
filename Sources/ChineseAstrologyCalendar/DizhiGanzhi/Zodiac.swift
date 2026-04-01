//
//  Zodiac.swift
//
//
//  Created by 孙翔宇 on 25/03/2020.
//

import Foundation

// MARK: - DizhiConvertible

/// Types that can be created from an Earthly Branch.
public protocol DizhiConvertible {
  /// Initializes an instance from ``Dizhi``.
  init(_ dizhi: Dizhi)
}

// MARK: - Zodiac

/// The twelve animals of the Chinese zodiac.
public enum Zodiac: String, DizhiConvertible, TraditionalChineseNaming, Sendable {
  case rat     = "鼠"
  case ox      = "牛"
  case tiger   = "虎"
  case rabbit  = "兔"
  case dragon  = "龙"
  case snake   = "蛇"
  case horse   = "马"
  case goat    = "羊"
  case monkey  = "猴"
  case rooster = "雞"
  case dog     = "狗"
  case pig     = "猪"

  // MARK: Lifecycle

  /// Converts the given ``Dizhi`` into its zodiac animal.
  public init(_ dizhi: Dizhi) {
    switch dizhi {
    case .zi:
      self = .rat
    case .chou:
      self = .ox
    case .yin:
      self = .tiger
    case .mao:
      self = .rabbit
    case .chen:
      self = .dragon
    case .si:
      self = .snake
    case .wu:
      self = .horse
    case .wei:
      self = .goat
    case .shen:
      self = .monkey
    case .you:
      self = .rooster
    case .xu:
      self = .dog
    case .hai:
      self = .pig
    }
  }

  // MARK: Public

  /// Traditional Chinese character for this zodiac animal.
  /// This is identical to `rawValue` and is provided for consistent API access.
  public var traditionalChineseName: String { rawValue }

  /// Emoji representation of the zodiac animal.
  public var emoji: String {
    switch self {
    case .rabbit:
      return "🐇"
    case .ox:
      return "🐂"
    case .dog:
      return "🐕"
    case .pig:
      return "🐖"
    case .monkey:
      return "🐵"
    case .goat:
      return "🐏"
    case .tiger:
      return "🐅"
    case .snake:
      return "🐍"
    case .rooster:
      return "🐓"
    case .horse:
      return "🐎"
    case .rat:
      return "🐀"
    case .dragon:
      return "🐉"
    }
  }
}
