/// Represents the days of a traditional Chinese lunar month.
public enum Day: Int, CaseIterable, Identifiable, Codable, Comparable, TraditionalChineseNaming, Sendable {
  case day1  = 1
  case day2
  case day3
  case day4
  case day5
  case day6
  case day7
  case day8
  case day9
  case day10
  case day11
  case day12
  case day13
  case day14
  case day15
  case day16
  case day17
  case day18
  case day19
  case day20
  case day21
  case day22
  case day23
  case day24
  case day25
  case day26
  case day27
  case day28
  case day29
  case day30

  // MARK: Public

  /// Numeric identifier for the day.
  public var id: Int {
    rawValue
  }

  /// Traditional Chinese textual representation for the day.
  public var name: String {
    switch self {
    case .day1:  return "初一"
    case .day2:  return "初二"
    case .day3:  return "初三"
    case .day4:  return "初四"
    case .day5:  return "初五"
    case .day6:  return "初六"
    case .day7:  return "初七"
    case .day8:  return "初八"
    case .day9:  return "初九"
    case .day10: return "初十"
    case .day11: return "十一"
    case .day12: return "十二"
    case .day13: return "十三"
    case .day14: return "十四"
    case .day15: return "十五"
    case .day16: return "十六"
    case .day17: return "十七"
    case .day18: return "十八"
    case .day19: return "十九"
    case .day20: return "二十"
    case .day21: return "廿一"
    case .day22: return "廿二"
    case .day23: return "廿三"
    case .day24: return "廿四"
    case .day25: return "廿五"
    case .day26: return "廿六"
    case .day27: return "廿七"
    case .day28: return "廿八"
    case .day29: return "廿九"
    case .day30: return "三十"
    }
  }

  /// Traditional Chinese character(s) for this day.
  public var traditionalChineseName: String { name }

  /// Associated moon phase for the day.
  public var moonPhase: ChineseMoonPhase {
    switch self {
    case .day1:
      return .newMoon
    case .day2, .day3, .day4, .day5, .day6:
      return .waxingCrescent
    case .day7, .day8:
      return .firstQuarter
    case .day9, .day10, .day11, .day12, .day13, .day14:
      return .waxingGibbous
    case .day15:
      return .fullMoon
    case .day16, .day17, .day18, .day19, .day20, .day21:
      return .waningGibbous
    case .day22, .day23:
      return .lastQuarter
    case .day24, .day25, .day26, .day27, .day28, .day29:
      return .waningCrescent
    case .day30:
      return .darkMoon
    }
  }

  /// Provides ordering support for ``Day`` values.
  public static func <(lhs: Day, rhs: Day) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}
