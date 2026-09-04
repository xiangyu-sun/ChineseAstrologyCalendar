import Foundation

// MARK: - TwelveGods + LocalizedNaming

/// Only the god's `name` is localized. `meaning`, `do`, `dontDo`, and
/// `xiongjiL` are dense almanac prose; auto-translating almanac guidance
/// risks introducing inaccurate advice, so those remain Traditional Chinese.
/// Inject your own translation if you need those fields localized.
extension TwelveGods: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language {
    case .zhHant: return traditionalChineseName
    case .zhHans: return Self.simplifiedNames[self] ?? traditionalChineseName
    case .en: return Self.englishNames[self] ?? traditionalChineseName
    }
  }

  // Only these four differ between Traditional and Simplified script.
  private static let simplifiedNames: [TwelveGods: String] = [
    .fullness: "满",
    .grasp: "执",
    .opening: "开",
    .closing: "闭",
  ]

  private static let englishNames: [TwelveGods: String] = [
    .establish: "Establish",
    .remove: "Remove",
    .fullness: "Fullness",
    .balance: "Balance",
    .stability: "Stability",
    .grasp: "Grasp",
    .destruction: "Destruction",
    .danger: "Danger",
    .completion: "Completion",
    .harvest: "Harvest",
    .opening: "Opening",
    .closing: "Closing",
  ]
}
