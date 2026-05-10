import Foundation

// MARK: - ChineseFestival

/// Traditional Chinese festivals and their lunar calendar dates.
///
/// Each festival is defined by either:
/// - A fixed lunar date (month + day)
/// - A solar term (Jieqi-based, e.g., Qingming)
///
/// Example:
/// ```swift
/// let converter = DayConverter()
/// let springFestival = ChineseFestival.springFestival
/// if let nextDate = springFestival.nextDate(from: Date(), converter: converter) {
///     print("Spring Festival: \(nextDate)")
/// }
/// ```
public enum ChineseFestival: CaseIterable, TraditionalChineseNaming, Sendable {

  // MARK: Fixed lunar-date festivals

  /// 春節 – Spring Festival / Chinese New Year (正月初一)
  case springFestival
  /// 元宵節 – Lantern Festival (正月十五)
  case lanternFestival
  /// 龍抬頭 – Dragon Raises Head (二月初二)
  case dragonRaisesHead
  /// 清明節 – Qingming / Tomb Sweeping (solar term)
  case qingming
  /// 端午節 – Dragon Boat Festival (五月初五)
  case dragonBoat
  /// 七夕 – Double Seventh / Chinese Valentine's Day (七月初七)
  case doubleSeventhNight
  /// 中元節 – Ghost Festival (七月十五)
  case ghostFestival
  /// 中秋節 – Mid-Autumn Festival (八月十五)
  case midAutumn
  /// 重陽節 – Double Ninth Festival (九月初九)
  case doubleNinth
  /// 冬至 – Winter Solstice (solar term)
  case dongzhi
  /// 臘八節 – Laba Festival (十二月初八)
  case laba
  /// 小年 – Little New Year / Kitchen God Festival (十二月廿三)
  case littleNewYear

  // MARK: Public

  /// Traditional Chinese name for this festival.
  public var traditionalChineseName: String { chineseName }

  /// Chinese name of the festival.
  public var chineseName: String {
    switch self {
    case .springFestival:    return "春節"
    case .lanternFestival:   return "元宵節"
    case .dragonRaisesHead:  return "龍抬頭"
    case .qingming:          return "清明節"
    case .dragonBoat:        return "端午節"
    case .doubleSeventhNight: return "七夕"
    case .ghostFestival:     return "中元節"
    case .midAutumn:         return "中秋節"
    case .doubleNinth:       return "重陽節"
    case .dongzhi:           return "冬至"
    case .laba:              return "臘八節"
    case .littleNewYear:     return "小年"
    }
  }

  /// A brief description of the festival.
  public var meaning: String {
    switch self {
    case .springFestival:
      return "農曆新年，一年中最重要的傳統節日，慶祝新年的開始。"
    case .lanternFestival:
      return "正月十五，觀賞花燈、猜燈謎，象徵新年節慶的結束。"
    case .dragonRaisesHead:
      return "二月初二，傳說龍王抬頭，為農耕季節的開始。"
    case .qingming:
      return "掃墓祭祖，緬懷先人，也是踏青郊遊的節日。"
    case .dragonBoat:
      return "五月初五，賽龍舟、吃粽子，紀念愛國詩人屈原。"
    case .doubleSeventhNight:
      return "七月初七，牛郎織女相會的日子，中國的情人節。"
    case .ghostFestival:
      return "七月十五，祭祀祖先亡魂，民間稱鬼節或盂蘭盆節。"
    case .midAutumn:
      return "八月十五，賞月、吃月餅，象徵家人團圓。"
    case .doubleNinth:
      return "九月初九，登高遠望、佩茱萸，也是敬老節。"
    case .dongzhi:
      return "冬至，一年中夜最長的一天，家人聚在一起吃湯圓。"
    case .laba:
      return "臘月初八，喝臘八粥，祈求新年豐收平安。"
    case .littleNewYear:
      return "臘月廿三，祭灶王爺，準備過年的開始。"
    }
  }

  /// The lunar month (1–12) for fixed lunar-date festivals, or `nil` for solar-term festivals.
  public var lunarMonth: Int? {
    switch self {
    case .springFestival:    return 1
    case .lanternFestival:   return 1
    case .dragonRaisesHead:  return 2
    case .qingming:          return nil
    case .dragonBoat:        return 5
    case .doubleSeventhNight: return 7
    case .ghostFestival:     return 7
    case .midAutumn:         return 8
    case .doubleNinth:       return 9
    case .dongzhi:           return nil
    case .laba:              return 12
    case .littleNewYear:     return 12
    }
  }

  /// The lunar day (1–30) for fixed lunar-date festivals, or `nil` for solar-term festivals.
  public var lunarDay: Int? {
    switch self {
    case .springFestival:    return 1
    case .lanternFestival:   return 15
    case .dragonRaisesHead:  return 2
    case .qingming:          return nil
    case .dragonBoat:        return 5
    case .doubleSeventhNight: return 7
    case .ghostFestival:     return 15
    case .midAutumn:         return 15
    case .doubleNinth:       return 9
    case .dongzhi:           return nil
    case .laba:              return 8
    case .littleNewYear:     return 23
    }
  }

  /// The associated Jieqi for solar-term-based festivals, or `nil` for lunar-date festivals.
  public var jieqi: Jieqi? {
    switch self {
    case .qingming: return .clearAndBright
    case .dongzhi:  return .winterSolstice
    default:        return nil
    }
  }

  /// Finds the next occurrence of this festival on or after the given date.
  ///
  /// For solar-term festivals (Qingming, Dongzhi), uses the `Date.jieqi` API.
  /// For lunar-date festivals, uses `DayConverter`.
  ///
  /// - Parameters:
  ///   - date: The reference date. Defaults to current date.
  ///   - converter: A `DayConverter` instance for lunar date calculations.
  /// - Returns: The Gregorian date of the next occurrence, or `nil` if not found.
  public func nextDate(from date: Date = Date(), converter: DayConverter = DayConverter()) -> Date? {
    // Check if the given date already falls on this festival
    if date.chineseFestival == self {
      return date
    }
    if let jieqiValue = jieqi {
      return nextJieqiDate(jieqiValue, from: date)
    }
    return nextLunarDate(from: date, converter: converter)
  }

  // MARK: Private

  private func nextLunarDate(from date: Date, converter: DayConverter) -> Date? {
    guard let month = lunarMonth, let day = lunarDay else { return nil }
    let lunarDayEnum = Day(rawValue: day)
    guard let lunarDayVal = lunarDayEnum else { return nil }
    // Map lunar month number to Dizhi (正月=寅, 二月=卯, …)
    let dizhiIndex = (month - 1) % Dizhi.orderedMonthAlCases.count
    let monthDizhi = Dizhi.orderedMonthAlCases[dizhiIndex]
    let events = converter.find(day: lunarDayVal, month: monthDizhi, inNextYears: 1, from: date)
    return events.first?.date
  }

  private func nextJieqiDate(_ targetJieqi: Jieqi, from date: Date) -> Date? {
    // Scan forward day by day (up to 400 days) until we find the jieqi transition
    let calendar = Calendar(identifier: .gregorian)
    var current = date
    for _ in 0..<400 {
      guard let next = calendar.date(byAdding: .day, value: 1, to: current) else { break }
      // Transition: previous day was a different jieqi, this day is the target
      let prevJieqi = current.jieqi
      let nextJieqi = next.jieqi
      if prevJieqi != nextJieqi, nextJieqi == targetJieqi {
        return next
      }
      current = next
    }
    return nil
  }
}

// MARK: - Date + ChineseFestival

extension Date {
  /// Returns the Chinese festival that falls on this date, if any.
  ///
  /// Checks against all fixed lunar-date festivals. Solar-term festivals
  /// (Qingming, Dongzhi) are matched by Jieqi.
  public var chineseFestival: ChineseFestival? {
    let chinCal = Calendar(identifier: .chinese)
    let components = chinCal.dateComponents([.month, .day], from: self)
    guard let month = components.month, let day = components.day else { return nil }

    // Check fixed lunar festivals
    for festival in ChineseFestival.allCases {
      if let fm = festival.lunarMonth, let fd = festival.lunarDay,
         fm == month, fd == day {
        return festival
      }
    }

    // Check solar-term festivals
    if let currentJieqi = self.jieqi {
      for festival in ChineseFestival.allCases {
        if festival.jieqi == currentJieqi {
          let greg = Calendar(identifier: .gregorian)
          if let yesterday = greg.date(byAdding: .day, value: -1, to: self),
             yesterday.jieqi != currentJieqi {
            return festival
          }
        }
      }
    }

    return nil
  }

  /// Returns the closest upcoming Chinese festival and the date it falls on.
  ///
  /// Searches all festivals for their next occurrence on or after `self`
  /// and returns the one with the earliest date.
  ///
  /// - Parameter converter: A `DayConverter` for lunar date calculations.
  /// - Returns: The soonest upcoming festival and its Gregorian date, or `nil` if none found.
  public func nextChineseFestival(converter: DayConverter = DayConverter()) -> (festival: ChineseFestival, date: Date)? {
    ChineseFestival.allCases
      .compactMap { festival -> (ChineseFestival, Date)? in
        guard let d = festival.nextDate(from: self, converter: converter) else { return nil }
        return (festival, d)
      }
      .min(by: { $0.1 < $1.1 })
  }
}
