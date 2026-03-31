import Foundation

// MARK: - Nayin

/// The sixty Nayin (納音) Five-Element associations for each Ganzhi combination.
///
/// Nayin is an ancient system where each of the 60 Ganzhi combinations is assigned
/// a special "sound element" description beyond the basic Five Elements. These are
/// used in traditional Chinese astrology, naming conventions, and fate calculation.
///
/// The 60 Jiazi pairs are grouped into 30 pairs, each pair sharing the same Nayin.
public enum Nayin: String, CaseIterable, Sendable {
  case 海中金
  case 炉中火
  case 大林木
  case 路旁土
  case 剑锋金
  case 山头火
  case 涧下水
  case 城头土
  case 白蜡金
  case 杨柳木
  case 泉中水
  case 屋上土
  case 霹雳火
  case 松柏木
  case 长流水
  case 沙中金
  case 山下火
  case 平地木
  case 壁上土
  case 金箔金
  case 覆灯火
  case 天河水
  case 大驿土
  case 钗钏金
  case 桑柘木
  case 大溪水
  case 沙中土
  case 天上火
  case 石榴木
  case 大海水

  /// The Wuxing (Five Element) category this Nayin belongs to.
  public var wuxing: Wuxing {
    switch self {
    case .海中金, .剑锋金, .白蜡金, .沙中金, .金箔金, .钗钏金:
      return .jin
    case .炉中火, .山头火, .霹雳火, .山下火, .覆灯火, .天上火:
      return .huo
    case .大林木, .杨柳木, .松柏木, .平地木, .桑柘木, .石榴木:
      return .mu
    case .路旁土, .城头土, .屋上土, .壁上土, .大驿土, .沙中土:
      return .tu
    case .涧下水, .泉中水, .长流水, .天河水, .大溪水, .大海水:
      return .shui
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
  /// print(jiazi.nayin) // 海中金
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
