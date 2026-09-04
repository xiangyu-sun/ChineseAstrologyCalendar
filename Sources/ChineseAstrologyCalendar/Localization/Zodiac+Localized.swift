import Foundation

extension Zodiac: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language {
    case .zhHant: return traditionalChineseName
    case .zhHans: return Self.simplifiedNames[self] ?? traditionalChineseName
    case .en: return Self.englishNames[self] ?? traditionalChineseName
    }
  }

  // Only these four differ between Traditional and Simplified script.
  private static let simplifiedNames: [Zodiac: String] = [
    .dragon: "龙",
    .horse: "马",
    .rooster: "鸡",
    .pig: "猪",
  ]

  private static let englishNames: [Zodiac: String] = [
    .rat: "Rat",
    .ox: "Ox",
    .tiger: "Tiger",
    .rabbit: "Rabbit",
    .dragon: "Dragon",
    .snake: "Snake",
    .horse: "Horse",
    .goat: "Goat",
    .monkey: "Monkey",
    .rooster: "Rooster",
    .dog: "Dog",
    .pig: "Pig",
  ]
}
