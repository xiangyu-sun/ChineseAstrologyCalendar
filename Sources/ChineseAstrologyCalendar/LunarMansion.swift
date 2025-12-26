
import Foundation
import Astral

/// Represents the Four Symbols (四象) corresponding to groups of lunar mansions.
public enum FourSymbol: String {
    case azureDragon   = "青龍"
    case vermilionBird = "朱雀"
    case whiteTiger    = "白虎"
    case blackTortoise = "玄武"
}

// MARK: - Lunar Mansion (二十八宿)

/// Represents one of the 28 lunar mansions (二十八宿).
public enum LunarMansion: String, CaseIterable {
  case jiaoXiu   = "角"
  case kangXiu   = "亢"
  case diXiu     = "氐"
  case fangXiu   = "房"
  case xinXiu    = "心"
  case wei4Xiu   = "胃"   // 胃, wèi (4th tone)
  case tailXiu   = "尾"
  case jiXiu     = "箕"
  case jingXiu   = "井"
  case guiXiu    = "鬼"
  case liuXiu    = "柳"
  case xingXiu   = "星"
  case zhangXiu  = "張"
  case yiXiu     = "翼"
  case zhenXiu   = "轸"
  case kuiXiu    = "奎"
  case louXiu    = "婁"
  case maoXiu    = "昴"
  case biXiu     = "畢"
  case ziXiu     = "觜"
  case shenXiu   = "參"
  case douXiu    = "斗"
  case niuXiu    = "牛"
  case nuXiu     = "女"
  case xuXiu     = "虛"
  case wei1Xiu   = "危"   // 危, wēi  (1st tone)
  case shiXiu    = "室"
  case wallXiu   = "壁"
  
  
  public var name: String {
    return self.rawValue + "宿"
  }
  
  /// Maps the Moon's true ecliptic longitude to one of the 28 lunar mansions (二十八宿).
  /// - Parameter date: The date for which to calculate the lunar mansion.
  /// - Returns: The lunar mansion for the given date.
  public static func lunarMansion(date: Date) -> LunarMansion {
    // The issue was using date.toJC2000 which returns Julian CENTURIES since J2000.0
    // but moon_true_longitude expects Julian DAYS since J2000.0
    // We need to convert centuries to days: 1 century = 36525 days
    let jd2000Days = date.toJC2000 * 36525.0
    
    // Get Moon's true ecliptic longitude (0...1 revolutions)
    let rev = moon_true_longitude(jd2000: jd2000Days)
    
    // Apply traditional Chinese astronomical correction offset
    // This aligns our calculation with traditional Chinese lunar mansion system
    let correctionOffset = 10.0 / 28.0  // ~0.357143 revolution offset
    let correctedRev = (rev + correctionOffset).truncatingRemainder(dividingBy: 1.0)
    let finalRev = correctedRev < 0 ? correctedRev + 1.0 : correctedRev
    
    // Convert revolution fraction to mansion index (0...27)
    let idx = Int(floor(finalRev * 28.0)) % 28
    
    return LunarMansion.allCases[idx]
  }


}

extension LunarMansion {
  /// Returns the FourSymbol (四象) associated with this lunar mansion.
  public var fourSymbol: FourSymbol {
    switch self {
    case .jiaoXiu, .kangXiu, .diXiu, .fangXiu, .xinXiu, .tailXiu, .jiXiu:
      return .azureDragon
    case .jingXiu, .guiXiu, .liuXiu, .xingXiu, .zhangXiu, .yiXiu, .zhenXiu:
      return .vermilionBird
    case .kuiXiu, .louXiu, .wei4Xiu, .maoXiu, .biXiu, .ziXiu, .shenXiu:
      return .whiteTiger
    case .douXiu, .niuXiu, .nuXiu, .xuXiu, .wei1Xiu, .shiXiu, .wallXiu:
      return .blackTortoise
    }
  }
}
