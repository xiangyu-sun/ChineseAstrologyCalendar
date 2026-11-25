import Foundation

extension FangWei: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant: return traditionalChineseName
    case .zhHans: return Self.simplifiedNames[self] ?? traditionalChineseName
    case .en: return Self.englishNames[self] ?? traditionalChineseName
    case .es: return Self.spanishNames[self] ?? traditionalChineseName
    }
  }

  // Only 東 differs from its Simplified form 东.
  private static let simplifiedNames: [FangWei: String] = [.east: "东"]

  private static let englishNames: [FangWei: String] = [
    .east: "East",
    .south: "South",
    .west: "West",
    .north: "North",
    .center: "Center",
  ]

  private static let spanishNames: [FangWei: String] = [
    .east: "Este",
    .south: "Sur",
    .west: "Oeste",
    .north: "Norte",
    .center: "Centro",
  ]
}
