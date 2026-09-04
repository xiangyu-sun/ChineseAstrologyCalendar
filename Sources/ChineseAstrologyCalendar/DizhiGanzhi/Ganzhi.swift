
import Foundation

// MARK: - Ganzhi

/// Represents a combination of a Heavenly Stem and an Earthly Branch.
public struct Ganzhi: CustomStringConvertible, Equatable, YinYangIdentifiable, Hashable, Sendable {
  public var yin: Bool {
    gan.yin && zhi.yin
  }

  let gan: Tiangan
  let zhi: Dizhi

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

extension String {
  /// Returns the string with only its first character uppercased.
  fileprivate var capitalizedFirstLetter: String {
    guard let first else { return self }
    return first.uppercased() + dropFirst()
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
