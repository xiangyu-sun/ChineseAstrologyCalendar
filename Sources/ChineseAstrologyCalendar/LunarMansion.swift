
import Foundation
import Astral

/// Represents the Four Symbols (四象) corresponding to groups of lunar mansions.
public enum FourSymbol: String, FangWeiConvertible, TraditionalChineseNaming {
    case azureDragon   = "青龍"
    case vermilionBird = "朱雀"
    case whiteTiger    = "白虎"
    case blackTortoise = "玄武"

    /// Traditional Chinese name for this symbol.
    /// This is identical to `rawValue` and is provided for consistent API access.
    public var traditionalChineseName: String { rawValue }

    /// Cardinal direction associated with this symbol.
    public var fangwei: FangWei {
        switch self {
        case .azureDragon:   return .east
        case .vermilionBird: return .south
        case .whiteTiger:    return .west
        case .blackTortoise: return .north
        }
    }
}

// MARK: - Lunar Mansion (二十八宿)

/// Represents one of the 28 lunar mansions (二十八宿) in traditional order.
/// The order follows: Eastern Azure Dragon → Northern Black Tortoise → Western White Tiger → Southern Vermillion Bird
public enum LunarMansion: String, CaseIterable, TraditionalChineseNaming {
  // Eastern Azure Dragon (東方青龍) - 7 mansions
  case horn             = "角"   // 角宿
  case neck             = "亢"   // 亢宿
  case root             = "氐"   // 氐宿
  case room             = "房"   // 房宿
  case heart            = "心"   // 心宿
  case tail             = "尾"   // 尾宿
  case winnowingBasket  = "箕"   // 箕宿

  // Northern Black Tortoise (北方玄武) - 7 mansions
  case dipper           = "斗"   // 斗宿
  case ox               = "牛"   // 牛宿
  case girl             = "女"   // 女宿
  case emptiness        = "虛"   // 虛宿
  case rooftop          = "危"   // 危宿
  case encampment       = "室"   // 室宿
  case wall             = "壁"   // 壁宿

  // Western White Tiger (西方白虎) - 7 mansions
  case legs             = "奎"   // 奎宿
  case bond             = "婁"   // 婁宿
  case stomach          = "胃"   // 胃宿
  case pleiades         = "昴"   // 昴宿
  case net              = "畢"   // 畢宿
  case turtleBeak       = "觜"   // 觜宿
  case threeStars       = "參"   // 參宿

  // Southern Vermillion Bird (南方朱雀) - 7 mansions
  case well             = "井"   // 井宿
  case ghost            = "鬼"   // 鬼宿
  case willow           = "柳"   // 柳宿
  case star             = "星"   // 星宿
  case extendedNet      = "張"   // 張宿
  case wings            = "翼"   // 翼宿
  case chariot          = "轸"   // 軫宿

  /// Traditional Chinese character(s) for this mansion.
  /// This is identical to `rawValue` and is provided for consistent API access.
  public var traditionalChineseName: String { rawValue }

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

extension LunarMansion: FangWeiConvertible {
  /// Returns the FourSymbol (四象) associated with this lunar mansion.
  public var fourSymbol: FourSymbol {
    switch self {
    case .horn, .neck, .root, .room, .heart, .tail, .winnowingBasket:
      return .azureDragon
    case .well, .ghost, .willow, .star, .extendedNet, .wings, .chariot:
      return .vermilionBird
    case .legs, .bond, .stomach, .pleiades, .net, .turtleBeak, .threeStars:
      return .whiteTiger
    case .dipper, .ox, .girl, .emptiness, .rooftop, .encampment, .wall:
      return .blackTortoise
    }
  }

  /// Cardinal direction associated with this lunar mansion via its ``FourSymbol``.
  public var fangwei: FangWei { fourSymbol.fangwei }
}
