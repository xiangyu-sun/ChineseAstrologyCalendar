import Foundation

/// 建、除、滿、平、定、執、破、危、成、收、開、閉
public enum TwelveGods: Int, CaseIterable {
  case jian = 0
  case chu
  case man
  case ping
  case ding
  case zhi
  case po
  case wei
  case cheng
  case shou
  case kai
  case bi
  
  public var chinese: String {
    switch self {
    case .jian: return "建"
    case .chu: return "除"
    case .man: return "滿"
    case .ping: return "平"
    case .ding: return "定"
    case .zhi: return "執"
    case .po: return "破"
    case .wei: return "危"
    case .cheng: return "成"
    case .shou: return "收"
    case .kai: return "開"
    case .bi: return "閉"
    }
  }
}

public extension Date {
  /// Returns the “建除十二神” for this date.
  func twelveGod() -> TwelveGods? {
    let greg = Calendar(identifier: .gregorian)
    let chin = Calendar(identifier: .chinese)
    
    // 1) lunar month (1...12)
    let lunarComp = chin.dateComponents([.year, .month, .day], from: self)
    guard let lunarMonth = lunarComp.month else { return nil }
    // Map lunar month to Earthly Branch: 正月=寅(3), 二月=卯(4), … 十一月=子(1), 十二月=丑(2)
    let monthBranchRaw = ((lunarMonth + 1) % 12) + 1
    guard let monthBranch = Dizhi(rawValue: monthBranchRaw) else { return nil }
    
    // 2) find the first day in that lunar month whose riZhi == monthBranch (the “建”日)
    guard let firstOfLunarMonth = chin.date(from: DateComponents(year: lunarComp.year,
                                                           month: lunarComp.month,
                                                                 day: 1)) else {
      return nil
    }
    var buildDate: Date? = nil
    for offset in 0..<30 {
      let candidate = greg.date(byAdding: .day, value: offset, to: firstOfLunarMonth)!
      if let branch = greg.dateComponents([.year, .month, .day], from: candidate).riZhi,
         branch == monthBranch {
        buildDate = candidate
        break
      }
    }
    guard let jianDate = buildDate else { return nil }
    
    // 2b) if that jian-day lies after self, roll back to previous month’s jian-day
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
      
      // map and find previous month’s jian
      let prevBranchRaw = ((prevMonth + 1) % 12) + 1
      guard let prevBranch = Dizhi(rawValue: prevBranchRaw) else { return nil }
      var prevBuild: Date? = nil
      for offset in 0..<30 {
        guard let candidate = greg.date(byAdding: .day, value: offset, to: firstOfPrev) else {
          break
        }
        
        if let branch = greg.dateComponents([.year, .month, .day], from: candidate).riZhi,
           branch == prevBranch {
          prevBuild = candidate
          break
        }
      }
      guard let prevJian = prevBuild else { return nil }
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
