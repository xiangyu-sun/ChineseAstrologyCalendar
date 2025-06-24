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
  
  public var meaning: String {
    switch self {
    case .jian:   return "象徵新的開始、創造和生長的力量。"
    case .chu:    return "象徵去除、清理與清掃的意義，適合除舊布新。"
    case .man:    return "象徵圓滿、完成與滿足，吉利之意。"
    case .ping:   return "象徵平和、穩定與調和，利於平安合和。"
    case .ding:   return "象徵安定、確立與決定，利於定契立約。"
    case .zhi:    return "象徵執著、約束與收攏，適合收拾、收斂。"
    case .po:     return "象徵破除、毀壞與決裂，利於破土、拆卸。"
    case .wei:    return "象徵危險、試煉與挑戰，適合冒險行事。"
    case .cheng:  return "象徵成就、成功與收穫，吉利之日。"
    case .shou:   return "象徵收藏、收取與集中，利於搬移收納。"
    case .kai:    return "象徵開啟、開放與始動，適合開工開業。"
    case .bi:     return "象徵閉合、結束與封藏，利於安葬與結束儀式。"
    }
  }
  
  public var `do`: String {
    switch self {
    case .jian:   return "開業、啟動計畫、嫁娶、安床。"
    case .chu:    return "除舊布新、掃除、裁衣、伐木。"
    case .man:    return "收割、交易、納財、祭祀。"
    case .ping:   return "市場交易、討價還價、調解、合約簽訂。"
    case .ding:   return "立約、定金、安葬、修造。"
    case .zhi:    return "收稅、執法、收賦、討債。"
    case .po:     return "拆卸、破土、動工、伐木。"
    case .wei:    return "冒險、試驗、競賽、體育活動。"
    case .cheng:  return "完成、成就、收成、婚慶。"
    case .shou:   return "收納、搬家、納畜、納穀。"
    case .kai:    return "開市、開業、旅行、動土。"
    case .bi:     return "閉門、結束會議、安葬、藏品封存。"
    }
  }
  
  public var dontDo: String {
    switch self {
    case .jian:   return "不宜葬禮、破土、搬家。"
    case .chu:    return "不宜婚嫁、開市、安門。"
    case .man:    return "不宜開業、開工、出行。"
    case .ping:   return "不宜動土、破土、開渠。"
    case .ding:   return "不宜嫁娶、出行、開張。"
    case .zhi:    return "不宜嫁娶、出行、動土。"
    case .po:     return "不宜婚嫁、入宅、開工。"
    case .wei:    return "不宜安葬、納財、開業。"
    case .cheng:  return "不宜動土、安葬、搬家。"
    case .shou:   return "不宜開市、開工、嫁娶。"
    case .kai:    return "不宜閉合、安門、安葬。"
    case .bi:     return "不宜開市、入宅、作灶。"
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
