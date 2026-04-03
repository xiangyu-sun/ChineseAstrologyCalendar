import Foundation

// MARK: - Nayin

/// The sixty Nayin (納音) Five-Element associations for each Ganzhi combination.
///
/// Nayin is an ancient system where each of the 60 Ganzhi combinations is assigned
/// a special "sound element" description beyond the basic Five Elements. These are
/// used in traditional Chinese astrology, naming conventions, and fate calculation.
///
/// The 60 Jiazi pairs are grouped into 30 pairs, each pair sharing the same Nayin.
public enum Nayin: String, CaseIterable, TraditionalChineseNaming, Sendable {
  case seaGold             = "海中金"
  case furnaceFire         = "爐中火"
  case forestWood          = "大林木"
  case roadsideEarth       = "路旁土"
  case swordEdgeMetal      = "劍鋒金"
  case mountaintopFire     = "山頭火"
  case ravineWater         = "澗下水"
  case rampartEarth        = "城頭土"
  case beeswaxMetal        = "白蠟金"
  case willowWood          = "楊柳木"
  case springWater         = "泉中水"
  case rooftopEarth        = "屋上土"
  case thunderFire         = "霹靂火"
  case pineWood            = "松柏木"
  case longRiverWater      = "長流水"
  case sandGold            = "沙中金"
  case footOfMountainFire  = "山下火"
  case flatlandWood        = "平地木"
  case wallEarth           = "壁上土"
  case goldLeafMetal       = "金箔金"
  case lanternFire         = "覆灯火"
  case celestialRiverWater = "天河水"
  case postRoadEarth       = "大驛土"
  case braceletMetal       = "釵釧金"
  case mulberryWood        = "桑柘木"
  case streamWater         = "大溪水"
  case sandEarth           = "沙中土"
  case heavenlyFire        = "天上火"
  case pomegranateWood     = "石榴木"
  case oceanWater          = "大海水"

  /// Traditional Chinese character(s) for this Nayin.
  /// This is identical to `rawValue` and is provided for consistent API access.
  public var traditionalChineseName: String { rawValue }

  /// The Wuxing (Five Element) category this Nayin belongs to.
  public var wuxing: Wuxing {
    switch self {
    case .seaGold, .swordEdgeMetal, .beeswaxMetal, .sandGold, .goldLeafMetal, .braceletMetal:
      return .metal
    case .furnaceFire, .mountaintopFire, .thunderFire, .footOfMountainFire, .lanternFire, .heavenlyFire:
      return .fire
    case .forestWood, .willowWood, .pineWood, .flatlandWood, .mulberryWood, .pomegranateWood:
      return .wood
    case .roadsideEarth, .rampartEarth, .rooftopEarth, .wallEarth, .postRoadEarth, .sandEarth:
      return .earth
    case .ravineWater, .springWater, .longRiverWater, .celestialRiverWater, .streamWater, .oceanWater:
      return .water
    }
  }
}

// MARK: - Ganzhi + Nayin

extension Ganzhi {

  /// Returns the Nayin (納音) element description for this Ganzhi combination.
  ///
  /// The 60 Jiazi combinations are paired (consecutive pairs share the same Nayin).
  /// The pair index (0–29) maps directly to a Nayin case.
  ///
  /// Example:
  /// ```swift
  /// let jiazi = Ganzhi(gan: .jia, zhi: .zi)
  /// print(jiazi.nayin) // seaGold (rawValue: "海中金")
  /// ```
  public var nayin: Nayin {
    // The 60 Jiazi list: pair index = floor((jiazi_index) / 2)
    // jiazi_index: 甲子=0, 乙丑=1, 丙寅=2, …
    // Each Tiangan goes jia(1),yi(2)..kui(10); each Dizhi goes zi(1)..hai(12)
    // The jiazi index within 0–59 is computed from the LCM cycle.
    let tianganIndex = gan.rawValue - 1  // 0–9
    let dizhiIndex = zhi.rawValue - 1    // 0–11
    // The 60-cycle index: since tiangan repeats every 10 and dizhi every 12,
    // we can compute: index = (tianganIndex * 6 + dizhiIndex * 5) % 60
    // Simpler: find position in the jiazi sequence
    // Position = first valid position where tiangan index matches mod 10
    // and dizhi index matches mod 12.
    // Since gcd(10,12)=2, valid combinations have same parity.
    // index in cycle: ((tianganIndex % 10) steps through with dizhi)
    // Standard formula: jiazi position = tianganIndex*6 (mod 60), but let's use
    // the canonical: for 甲子(0), 乙丑(1), 丙寅(2)…
    // The cycle always increments both stem and branch by 1 together.
    // Starting from 甲子(jia=1,zi=1): index = (tianganIndex - dizhiIndex%10 ... )
    // Reliable approach: scan the getJiazhi() list
    let all = getJiazhi()
    let position = all.firstIndex(of: self) ?? 0
    let pairIndex = position / 2
    let allNayin = Nayin.allCases
    return allNayin[pairIndex % allNayin.count]
  }
}
