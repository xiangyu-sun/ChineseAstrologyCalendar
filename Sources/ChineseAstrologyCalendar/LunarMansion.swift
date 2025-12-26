
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

/// Represents one of the 28 lunar mansions (二十八宿) in traditional order.
/// The order follows: Eastern Azure Dragon → Northern Black Tortoise → Western White Tiger → Southern Vermillion Bird
public enum LunarMansion: String, CaseIterable {
  // Eastern Azure Dragon (東方青龍) - 7 mansions
  case jiaoXiu   = "角"   // Horn
  case kangXiu   = "亢"   // Neck
  case diXiu     = "氐"   // Root
  case fangXiu   = "房"   // Room
  case xinXiu    = "心"   // Heart
  case tailXiu   = "尾"   // Tail
  case jiXiu     = "箕"   // Winnowing Basket
  
  // Northern Black Tortoise (北方玄武) - 7 mansions
  case douXiu    = "斗"   // Dipper
  case niuXiu    = "牛"   // Ox
  case nuXiu     = "女"   // Girl
  case xuXiu     = "虛"   // Emptiness
  case wei1Xiu   = "危"   // Danger (wēi, 1st tone)
  case shiXiu    = "室"   // Room
  case wallXiu   = "壁"   // Wall
  
  // Western White Tiger (西方白虎) - 7 mansions
  case kuiXiu    = "奎"   // Legs
  case louXiu    = "婁"   // Bond
  case wei4Xiu   = "胃"   // Stomach (wèi, 4th tone)
  case maoXiu    = "昴"   // Pleiades
  case biXiu     = "畢"   // Net
  case ziXiu     = "觜"   // Turtle Beak
  case shenXiu   = "參"   // Three Stars
  
  // Southern Vermillion Bird (南方朱雀) - 7 mansions
  case jingXiu   = "井"   // Well
  case guiXiu    = "鬼"   // Ghost
  case liuXiu    = "柳"   // Willow
  case xingXiu   = "星"   // Star
  case zhangXiu  = "張"   // Extended Net
  case yiXiu     = "翼"   // Wings
  case zhenXiu   = "轸"   // Chariot

  
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
    
    let correctionOffset = 13.0 / 28.0
    let correctedRev = (rev + correctionOffset).truncatingRemainder(dividingBy: 1.0)
    let finalRev = correctedRev < 0 ? correctedRev + 1.0 : correctedRev
    
    // Convert revolution fraction to mansion index (0...27)
    let idx = Int(finalRev * 28.0) % 28
    
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
