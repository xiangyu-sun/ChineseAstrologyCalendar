import Foundation

/// 建、除、滿、平、定、執、破、危、成、收、開、閉
public enum TwelveGods: Int, CaseIterable, TraditionalChineseNaming {
  case establish = 0  // 建
  case remove         // 除
  case fullness       // 滿
  case balance        // 平
  case stability      // 定
  case grasp          // 執
  case destruction    // 破
  case danger         // 危
  case completion     // 成
  case harvest        // 收
  case opening        // 開
  case closing        // 閉

  /// Pinyin representation of this god.
  public var pinYinWithoutAccent: String {
    switch self {
    case .establish:   return "jian"
    case .remove:      return "chu"
    case .fullness:    return "man"
    case .balance:     return "ping"
    case .stability:   return "ding"
    case .grasp:       return "zhi"
    case .destruction: return "po"
    case .danger:      return "wei"
    case .completion:  return "cheng"
    case .harvest:     return "shou"
    case .opening:     return "kai"
    case .closing:     return "bi"
    }
  }

  /// Traditional Chinese character for this god.
  public var chinese: String {
    switch self {
    case .establish:   return "建"
    case .remove:      return "除"
    case .fullness:    return "滿"
    case .balance:     return "平"
    case .stability:   return "定"
    case .grasp:       return "執"
    case .destruction: return "破"
    case .danger:      return "危"
    case .completion:  return "成"
    case .harvest:     return "收"
    case .opening:     return "開"
    case .closing:     return "閉"
    }
  }

  /// Traditional Chinese character for this god.
  public var traditionalChineseName: String { chinese }

  public var xiongjiL: String {
    switch self {
    case .establish:
      "黑道"
    case .remove:
      "黃道"
    case .fullness:
      "黑道"
    case .balance:
      "黑道"
    case .stability:
      "黃道"
    case .grasp:
      "黃道"
    case .destruction:
      "大凶"
    case .danger:
      "黃道"
    case .completion:
      "平日"
    case .harvest:
      "黑道"
    case .opening:
      "平日"
    case .closing:
      "大凶"
    }
  }

  public var meaning: String {
    switch self {
    case .establish:   return "象徵新的開始、創造和生長的力量。"
    case .remove:      return "象徵去除、清理與清掃的意義，適合除舊布新。"
    case .fullness:    return "象徵圓滿、完成與滿足，吉利之意。"
    case .balance:     return "象徵平和、穩定與調和，利於平安合和。"
    case .stability:   return "象徵安定、確立與決定，利於定契立約。"
    case .grasp:       return "象徵執著、約束與收攏，適合收拾、收斂。"
    case .destruction: return "象徵破除、毀壞與決裂，利於破土、拆卸。"
    case .danger:      return "象徵危險、試煉與挑戰，適合冒險行事。"
    case .completion:  return "象徵成就、成功與收穫，吉利之日。"
    case .harvest:     return "象徵收藏、收取與集中，利於搬移收納。"
    case .opening:     return "象徵開啟、開放與始動，適合開工開業。"
    case .closing:     return "象徵閉合、結束與封藏，利於安葬與結束儀式。"
    }
  }

  public var `do`: String {
    switch self {
    case .establish:   return "祈福、祈禱、求嗣、破土、安葬、修造、上樑、求財、置業、入學、考試、結婚、動土、簽約、交涉、出行"
    case .remove:      return "祭祀、祈福、嫁娶、出行、入伙、搬遷、出貨、動土、求醫、交易"
    case .fullness:    return "祈福、移徙、開市、交易、求財、立契、祭祀、出行、牧養"
    case .balance:     return "嫁娶、修造、破土、安葬、牧養、開市、安床、動土、求嗣"
    case .stability:   return "祭祀、祈福、嫁娶、造屋、裝修、修路、開市、入學、上任、入伙"
    case .grasp:       return "造屋、裝修、嫁娶、收納、立契、祭祀"
    case .destruction: return "破土、拆卸、求醫"
    case .danger:      return "祭祀、祈福、安床、拆卸、破土"
    case .completion:  return "結婚、開市、修造、動土、安床、安葬、搬遷、交易、求財、出行、立契"
    case .harvest:     return "祈福、求嗣、赴任、嫁娶、安床、修造、動土、求學、開市、交易、買賣、立契"
    case .opening:     return "祭祀、祈福、入學、上任、修造、動土、開市、安床、交易、出行"
    case .closing:     return "祭祀、祈福、築堤、造葬、填井、修屋"
    }
  }

  public var dontDo: String {
    switch self {
    case .establish:   return "動土、開倉、掘井、乘船、新險下水、新車下地、維修電器"
    case .remove:      return "結婚、赴任、遠行、簽約"
    case .fullness:    return "造葬、赴任、求醫、嫁娶"
    case .balance:     return "祈福、求嗣、赴任、嫁娶、開市、安葬"
    case .stability:   return "訴訟、出行、交涉"
    case .grasp:       return "開市、求財、出行、搬遷"
    case .destruction: return "娶嫁，簽約，交涉，出行，搬遷"
    case .danger:      return "登山、乘船、出行、嫁娶、造葬、征徙"
    case .completion:  return "訴訟"
    case .harvest:     return "放債、新險下水、新車下地、破土、安葬"
    case .opening:     return "放債、訴訟、安葬"
    case .closing:     return "開市、出行、求醫、手術、嫁娶"
    }
  }

}

public extension Date {
  /// Returns the "建除十二神" for this date.
  func twelveGod() -> TwelveGods? {
    let greg = Calendar(identifier: .gregorian)
    let chin = Calendar(identifier: .chinese)

    // 1) lunar month (1...12)
    let lunarComp = chin.dateComponents([.year, .month, .day], from: self)
    guard let lunarMonth = lunarComp.month else { return nil }
    // Map lunar month to Earthly Branch: 正月=寅(3), 二月=卯(4), … 十一月=子(1), 十二月=丑(2)
    let monthBranchRaw = ((lunarMonth + 1) % 12) + 1
    guard let monthBranch = Dizhi(rawValue: monthBranchRaw) else { return nil }

    // 2) find the "建" day in that lunar month: collect all riZhi == monthBranch dates, pick second if available
    guard let firstOfLunarMonth = chin.date(from: DateComponents(year: lunarComp.year,
                                                                 month: lunarComp.month,
                                                                 day: 1)) else {
      return nil
    }
    var buildDates: [Date] = []
    for offset in 0..<30 {
      guard let candidate = greg.date(byAdding: .day, value: offset, to: firstOfLunarMonth) else {
        break
      }
      if let branch = greg.dateComponents([.year, .month, .day], from: candidate).riZhi,
         branch == monthBranch {
        buildDates.append(candidate)
      }
    }
    guard !buildDates.isEmpty else { return nil }
    let jianDate = buildDates.count > 1 ? buildDates[1] : buildDates[0]

    // 2b) if that jian-day lies after self, roll back to previous month's jian-day
    let effectiveJianDate: Date
    if let year = lunarComp.year, jianDate > self {
      // previous lunar month/year
      let prevMonth = lunarMonth > 1 ? lunarMonth - 1 : 12
      let prevYear  = lunarMonth > 1 ? year : year - 1

      guard let firstOfPrev = chin.date(from: DateComponents(year: prevYear,
                                                             month: prevMonth,
                                                             day: 1)) else {
        return nil
      }

      // map and find previous month's jian: collect all matches, pick second if available
      let prevBranchRaw = ((prevMonth + 1) % 12) + 1
      guard let prevBranch = Dizhi(rawValue: prevBranchRaw) else { return nil }
      var prevBuildDates: [Date] = []
      for offset in 0..<30 {
        guard let candidate = greg.date(byAdding: .day, value: offset, to: firstOfPrev) else {
          break
        }
        if let branch = greg.dateComponents([.year, .month, .day], from: candidate).riZhi,
           branch == prevBranch {
          prevBuildDates.append(candidate)
        }
      }
      guard !prevBuildDates.isEmpty else { return nil }
      let prevJian = prevBuildDates.count > 1 ? prevBuildDates[1] : prevBuildDates[0]
      effectiveJianDate = prevJian
    } else {
      effectiveJianDate = jianDate
    }

    // 3) days difference mod 12 → god index
    guard let days = greg.dateComponents([.day], from: effectiveJianDate, to: self).day else {
      return nil
    }

    let idx  = (days % 12 + 12) % 12  // ensure 0…11
    return TwelveGods(rawValue: idx)
  }
}
