
import Foundation

// MARK: - Ganzhi

/// Represents a combination of a Heavenly Stem and an Earthly Branch.
public struct Ganzhi: CustomStringConvertible, Equatable, YinYangIdentifiable, Hashable, Sendable {
  public var yin: Bool {
    gan.yin && zhi.yin
  }

  /// The Heavenly Stem (天干) of this pair.
  public let gan: Tiangan
  /// The Earthly Branch (地支) of this pair.
  public let zhi: Dizhi

  /// String value of the stem and branch combined.
  public var description: String {
    gan.chineseCharacter + zhi.chineseCharacter
  }

  /// Hanyu Pinyin romanization of the stem-branch pair, with tone marks
  /// (e.g. `"Guǐmǎo"` for 癸卯).
  public var pinyin: String {
    (gan.pinyin + zhi.pinyin).capitalizedFirstLetter
  }
}

extension Ganzhi {

  /// Creates a stem-branch pair, or returns `nil` if the pair never occurs in
  /// the sixty-term cycle.
  ///
  /// Only pairs whose stem and branch share yin/yang polarity are valid, so
  /// 甲子 exists but 甲丑 does not.
  /// ```swift
  /// Ganzhi(.jia, .zi)   // 甲子
  /// Ganzhi(.jia, .chou) // nil
  /// ```
  public init?(_ gan: Tiangan, _ zhi: Dizhi) {
    guard gan.rawValue % 2 == zhi.rawValue % 2 else { return nil }
    self.init(gan: gan, zhi: zhi)
  }

  /// Creates the pair at the given zero-based position in the sixty-term
  /// cycle (0 = 甲子 … 59 = 癸亥). Out-of-range indices wrap.
  public init(jiaziIndex: Int) {
    let index = ((jiaziIndex % 60) + 60) % 60
    // Both stem and branch advance by one each step, starting from 甲子.
    self.init(gan: Tiangan(rawValue: index % 10 + 1)!, zhi: Dizhi(rawValue: index % 12 + 1)!)
  }

  /// Zero-based position of this pair in the sixty-term cycle (甲子 = 0 … 癸亥 = 59).
  public var jiaziIndex: Int {
    // Solves n ≡ stem (mod 10) and n ≡ branch (mod 12) for n in 0..<60.
    let stem = gan.rawValue - 1
    let branch = zhi.rawValue - 1
    return ((6 * stem - 5 * branch) % 60 + 60) % 60
  }
}

extension Ganzhi {
  /// Returns the formatted year string with the stem and branch.
  public var formatedYear: String {
    description + "年"
  }

  /// Returns the formatted month string with the stem and branch.
  public var formatedMonth: String {
    description + "月"
  }
}
