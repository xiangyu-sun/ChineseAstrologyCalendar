//
//  Zodiac.swift
//
//
//  Created by 孙翔宇 on 25/03/2020.
//

import Foundation

// MARK: - DizhiConvertible

public protocol DizhiConvertible {
  init(_ dizhi: Dizhi)
}

// MARK: - Zodiac

public enum Zodiac: String, DizhiConvertible {
  case 鼠, 牛, 虎, 兔, 龙, 蛇, 马, 羊, 猴, 雞, 狗, 猪

  // MARK: Lifecycle

  public init(_ dizhi: Dizhi) {
    switch dizhi {
    case .zi:
      self = .鼠
    case .chou:
      self = .牛
    case .yin:
      self = .虎
    case .mao:
      self = .兔
    case .chen:
      self = .龙
    case .si:
      self = .蛇
    case .wu:
      self = .马
    case .wei:
      self = .羊
    case .shen:
      self = .猴
    case .you:
      self = .雞
    case .xu:
      self = .狗
    case .hai:
      self = .猪
    }
  }

  // MARK: Public

  public var emoji: String {
    switch self {
    case .兔:
      return "🐇"
    case .牛:
      return "🐂"
    case .狗:
      return "🐕"
    case .猪:
      return "🐖"
    case .猴:
      return "🐵"
    case .羊:
      return "🐏"
    case .虎:
      return "🐅"
    case .蛇:
      return "🐍"
    case .雞:
      return "🐓"
    case .马:
      return "🐎"
    case .鼠:
      return "🐀"
    case .龙:
      return "🐉"
    }
  }
}
