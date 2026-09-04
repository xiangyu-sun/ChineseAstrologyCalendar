import Foundation

extension Wuxing: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language {
    case .zhHant, .zhHans: return traditionalChineseName // 金木水火土 identical in both scripts
    case .en: return Self.englishNames[self] ?? traditionalChineseName
    }
  }

  /// The traditional color associated with this element, in the given language.
  public func localizedColorDescription(in language: DisplayLanguage) -> String {
    switch language {
    case .zhHant: return colorDescription
    case .zhHans: return Self.simplifiedColors[self] ?? colorDescription
    case .en: return Self.englishColors[self] ?? colorDescription
    }
  }

  /// The traditional flavor associated with this element, in the given language.
  public func localizedFlavor(in language: DisplayLanguage) -> String {
    switch language {
    case .zhHant: return fiveFlavor
    case .zhHans: return Self.simplifiedFlavors[self] ?? fiveFlavor
    case .en: return Self.englishFlavors[self] ?? fiveFlavor
    }
  }

  // MARK: Private

  private static let englishNames: [Wuxing: String] = [
    .wood: "Wood",
    .fire: "Fire",
    .earth: "Earth",
    .metal: "Metal",
    .water: "Water",
  ]

  // Only 黃 (earth's color) differs from its Simplified form 黄.
  private static let simplifiedColors: [Wuxing: String] = [.earth: "黄"]

  private static let englishColors: [Wuxing: String] = [
    .metal: "White",
    .wood: "Green",
    .water: "Black",
    .fire: "Red",
    .earth: "Yellow",
  ]

  // Only 鹹 (water's flavor) differs from its Simplified form 咸.
  private static let simplifiedFlavors: [Wuxing: String] = [.water: "咸"]

  private static let englishFlavors: [Wuxing: String] = [
    .wood: "Sour",
    .fire: "Bitter",
    .earth: "Sweet",
    .metal: "Pungent",
    .water: "Salty",
  ]
}
