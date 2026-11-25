import Foundation

extension Zodiac: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant: return traditionalChineseName
    case .zhHans: return Self.simplifiedNames[self] ?? traditionalChineseName
    case .en: return Self.englishNames[self] ?? traditionalChineseName
    case .es: return Self.spanishNames[self] ?? traditionalChineseName
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

  private static let spanishNames: [Zodiac: String] = [
    .rat: "Rata",
    .ox: "Buey",
    .tiger: "Tigre",
    .rabbit: "Conejo",
    .dragon: "Dragón",
    .snake: "Serpiente",
    .horse: "Caballo",
    .goat: "Cabra",
    .monkey: "Mono",
    .rooster: "Gallo",
    .dog: "Perro",
    .pig: "Cerdo",
  ]
}
