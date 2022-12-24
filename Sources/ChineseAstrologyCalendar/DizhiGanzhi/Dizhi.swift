//
//  Dizhi.swift
//
//
//  Created by 孙翔宇 on 25/03/2020.
//

import Foundation

// MARK: - TimeExpressible

public protocol TimeExpressible {
  init(hourOfDay: Int)
  var chineseCharactor: String { get }
  var displayHourText: String { get }
}

// MARK: - MonthExpressible

public protocol MonthExpressible {
  var displayMonthText: String { get }
}

// MARK: - DizhiConvertable

public protocol DizhiConvertable {
  var dizhi: Dizhi? { get }
}

// MARK: - Dizhi

public enum Dizhi: Int, CaseIterable, Comparable, Identifiable, YinYangIdentifiable {
  case zi = 1, chou, yin, mao, chen, si, wu, wei, shen, you, xu, hai

  // MARK: Public

  public static let orderedMonthAlCases: [Dizhi] = [.yin, .mao, .chen, .si, .wu, .wei, .shen, .you, .xu, .hai, .zi, .chou]

  public static let xiaDynastyYearOrder: [Dizhi] = [
    .hai,
    .zi,
    .chou,
    .yin,
    .mao,
    .chen,
    .si,
    .wu,
    .wei,
    .shen,
    .you,
    .xu,
  ]

  public var id: Int {
    rawValue
  }
    
    public var jie: Jieqi {
        let base = rawValue * 2 - 1
        return Jieqi(rawValue: base) ?? .lichun
    }
    
    public var qi: Jieqi{
        let base = rawValue * 2 - 1
        return Jieqi(rawValue: base + 1) ?? .lichun
    }
    
    public var monthIndex: Int {
        (Dizhi.orderedMonthAlCases.firstIndex(of: self) ?? 0) + 1
    }


  public var chineseCharactor: String {
    switch self {
    case .zi:
      return "子"
    case .chou:
      return "丑"
    case .yin:
      return "寅"
    case .mao:
      return "卯"
    case .chen:
      return "辰"
    case .si:
      return "巳"
    case .wu:
      return "午"
    case .wei:
      return "未"
    case .shen:
      return "申"
    case .you:
      return "酉"
    case .xu:
      return "戌"
    case .hai:
      return "亥"
    }
  }

  public var aliasName: String {
    switch self {
    case .zi:
      return "夜半"
    case .chou:
      return "雞鳴"
    case .yin:
      return "平旦"
    case .mao:
      return "日出"
    case .chen:
      return "食時"
    case .si:
      return "隅中"
    case .wu:
      return "日中"
    case .wei:
      return "日昳"
    case .shen:
      return "晡時"
    case .you:
      return "日入"
    case .xu:
      return "黄昏"
    case .hai:
      return "人定"
    }
  }

  public var organReference: String {
    switch self {
    case .zi:
      return "膽"
    case .chou:
      return "肝"
    case .yin:
      return "肺"
    case .mao:
      return "大腸"
    case .chen:
      return "胃"
    case .si:
      return "脾"
    case .wu:
      return "心"
    case .wei:
      return "小腸"
    case .shen:
      return "膀胱"
    case .you:
      return "腎"
    case .xu:
      return "心包"
    case .hai:
      return "三焦"
    }
  }

  public var wuxing: Wuxing {
    switch self {
    case .yin, .mao:
      return .mu
    case .si, .wu:
      return .huo
    case .shen, .you:
      return .jin
    case .hai, .zi:
      return .shui
    case .chen, .wei, .chou,. xu:
      return .tu
    }
  }

  public var next: Dizhi {
    guard let nextDizhi = Dizhi(rawValue: rawValue + 1) else {
      return .zi
    }
    return nextDizhi
  }

  public var previous: Dizhi {
    guard let previousDizhi = Dizhi(rawValue: rawValue - 1) else {
      return .hai
    }
    return previousDizhi
  }

  public static func < (lhs: Dizhi, rhs: Dizhi) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

// MARK: - HourInterval

public struct HourInterval<T> where T: Comparable {
  let start: T
  let end: T
}

// MARK: - Dizhi + TimeExpressible

extension Dizhi: TimeExpressible {

  // MARK: Lifecycle

  public init(hourOfDay: Int) {
    switch hourOfDay {
    case 23, 0:
      self = .zi
    case 1, 2:
      self = .chou
    case 3, 4:
      self = .yin
    case 5, 6:
      self = .mao
    case 7, 8:
      self = .chen
    case 9, 10:
      self = .si
    case 11, 12:
      self = .wu
    case 13, 14:
      self = .wei
    case 15, 16:
      self = .shen
    case 17, 18:
      self = .you
    case 19, 20:
      self = .xu
    case 21, 22:
      self = .hai
    default:
      self = .zi
    }
  }

  // MARK: Public

  public var hourInterval: HourInterval<Int> {
    switch self {
    case .zi:
      return .init(start: 23, end: 0)
    case .chou:
      return .init(start: 1, end: 2)
    case .yin:
      return .init(start: 3, end: 4)
    case .mao:
      return .init(start: 5, end: 6)
    case .chen:
      return .init(start: 7, end: 8)
    case .si:
      return .init(start: 9, end: 10)
    case .wu:
      return .init(start: 11, end: 12)
    case .wei:
      return .init(start: 13, end: 14)
    case .shen:
      return .init(start: 15, end: 16)
    case .you:
      return .init(start: 17, end: 18)
    case .xu:
      return .init(start: 19, end: 20)
    case .hai:
      return .init(start: 21, end: 22)
    }
  }

  public var formattedHourRange: String? {
    guard let date = Calendar.current.date(bySettingHour: hourInterval.start, minute: 0, second: 0, of: Date())
    else { return nil }

    return Dizhi.dateIntervalFormatter.string(from: DateInterval(start: date, duration: 60 * 60 * 2))
  }

  public var formattedShortHourRange: String? {
    guard let date = Calendar.current.date(bySettingHour: hourInterval.start, minute: 0, second: 0, of: Date())
    else { return nil }

    return Dizhi.hourIntervalFormatter.string(from: DateInterval(start: date, duration: 60 * 60 * 2))
  }
    

  public var formattedMonth: String {
    let date = Calendar.current.date(bySetting: .month, value: monthIndex, of: Date()) ?? Date()
    return Dizhi.monthFormatter.string(from: date)
  }

  public var displayHourText: String { chineseCharactor + "時" }

  public var chineseCalendarMonthName: String {
    chineseCharactor + "月"
  }

  // MARK: Internal

  static var dateIntervalFormatter: DateIntervalFormatter = {
    let fm = DateIntervalFormatter()
    fm.dateTemplate = "jm"
    return fm
  }()

  static var hourIntervalFormatter: DateIntervalFormatter = {
    let fm = DateIntervalFormatter()
    fm.dateTemplate = "HH:mm"
    return fm
  }()

  static var monthFormatter: DateFormatter = {
    let dfm = DateFormatter()
    dfm.locale = tranditonalChineseLocal
    dfm.dateFormat = "MMMM"
    return dfm
  }()
}
