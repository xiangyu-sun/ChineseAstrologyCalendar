import Foundation

// MARK: - ChineseMoonPhase + LocalizedNaming

/// Localizes the *modern* Chinese moon-phase name (see `modernChineseName(_:)`).
/// The historical/ancient name (`rawValue`, e.g. 朔, 望, 晦) is canonical
/// terminology and is not translated.
extension ChineseMoonPhase: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language {
    case .zhHant: return Self.traditionalModernNames[self] ?? traditionalChineseName
    case .zhHans: return Self.simplifiedModernNames[self] ?? Self.traditionalModernNames[self] ?? traditionalChineseName
    case .en: return Self.englishNames[self] ?? traditionalChineseName
    }
  }

  private static let traditionalModernNames: [ChineseMoonPhase: String] = [
    .newMoon: "新月",
    .waxingCrescent: "上蛾眉月",
    .firstQuarter: "上弦月",
    .waxingGibbous: "漸盈凸月",
    .fullMoon: "滿月",
    .waningGibbous: "漸虧凸月",
    .lastQuarter: "下弦月",
    .waningCrescent: "下蛾眉月",
    .darkMoon: "晦",
  ]

  // Only these three differ between Traditional and Simplified script.
  private static let simplifiedModernNames: [ChineseMoonPhase: String] = [
    .fullMoon: "满月",
    .waxingGibbous: "渐盈凸月",
    .waningGibbous: "渐亏凸月",
  ]

  private static let englishNames: [ChineseMoonPhase: String] = [
    .newMoon: "New Moon",
    .waxingCrescent: "Waxing Crescent",
    .firstQuarter: "First Quarter",
    .waxingGibbous: "Waxing Gibbous",
    .fullMoon: "Full Moon",
    .waningGibbous: "Waning Gibbous",
    .lastQuarter: "Last Quarter",
    .waningCrescent: "Waning Crescent",
    .darkMoon: "Dark Moon",
  ]
}
