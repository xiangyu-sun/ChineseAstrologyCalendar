import Foundation

extension Wuxing: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant, .zhHans: return traditionalChineseName // 金木水火土 identical in both scripts
    case .en: return Self.englishNames[self] ?? traditionalChineseName
    case .es: return Self.spanishNames[self] ?? traditionalChineseName
    }
  }

  /// The traditional color associated with this element, in the given language.
  public func localizedColorDescription(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant: return colorDescription
    case .zhHans: return Self.simplifiedColors[self] ?? colorDescription
    case .en: return Self.englishColors[self] ?? colorDescription
    case .es: return Self.spanishColors[self] ?? colorDescription
    }
  }

  /// The traditional flavor associated with this element, in the given language.
  public func localizedFlavor(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant: return fiveFlavor
    case .zhHans: return Self.simplifiedFlavors[self] ?? fiveFlavor
    case .en: return Self.englishFlavors[self] ?? fiveFlavor
    case .es: return Self.spanishFlavors[self] ?? fiveFlavor
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

  private static let spanishNames: [Wuxing: String] = [
    .wood: "Madera",
    .fire: "Fuego",
    .earth: "Tierra",
    .metal: "Metal",
    .water: "Agua",
  ]

  private static let spanishColors: [Wuxing: String] = [
    .metal: "Blanco",
    .wood: "Verde",
    .water: "Negro",
    .fire: "Rojo",
    .earth: "Amarillo",
  ]

  private static let spanishFlavors: [Wuxing: String] = [
    .wood: "Ácido",
    .fire: "Amargo",
    .earth: "Dulce",
    .metal: "Picante",
    .water: "Salado",
  ]
}
