import Foundation

// MARK: - Tiangan + LocalizedNaming

/// The ten stems are written identically in Traditional and Simplified script.
/// English and Spanish have no established translation, so they use capitalized
/// Hanyu Pinyin.
extension Tiangan: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant, .zhHans: return chineseCharacter
    case .en, .es: return pinyin.capitalizedFirstLetter
    }
  }
}

// MARK: - Dizhi + LocalizedNaming

/// The twelve branches are written identically in Traditional and Simplified
/// script. English and Spanish use capitalized Hanyu Pinyin.
extension Dizhi: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant, .zhHans: return chineseCharacter
    case .en, .es: return pinyin.capitalizedFirstLetter
    }
  }

  /// The name of the double-hour (時辰) governed by this branch, e.g. 子時 / 子时 /
  /// "Zǐ hour" / "Hora Zǐ".
  ///
  /// Equivalent to ``displayHourText`` for `.zhHant`.
  public func localizedHourName(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant: return displayHourText
    case .zhHans: return chineseCharacter + "时"
    case .en: return "\(localizedName(in: .en)) hour"
    case .es: return "Hora \(localizedName(in: .es))"
    }
  }
}

// MARK: - Ganzhi + LocalizedNaming

/// Stem-branch pairs read the same in both Chinese scripts. English and Spanish
/// use capitalized Hanyu Pinyin, e.g. "Guǐmǎo" for 癸卯.
extension Ganzhi: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant, .zhHans: return description
    case .en, .es: return pinyin
    }
  }
}

extension String {
  /// Returns the string with only its first character uppercased.
  var capitalizedFirstLetter: String {
    guard let first else { return self }
    return first.uppercased() + dropFirst()
  }
}
