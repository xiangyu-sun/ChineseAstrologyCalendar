import Foundation

// MARK: - LunarMansion + LocalizedNaming

/// Chinese names include the 宿 suffix (角宿), matching ``LunarMansion/name``.
extension LunarMansion: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant: return name
    case .zhHans: return (Self.simplifiedCharacters[self] ?? rawValue) + "宿"
    case .en: return Self.englishNames[self] ?? name
    }
  }

  // Characters not listed are identical in both scripts.
  private static let simplifiedCharacters: [LunarMansion: String] = [
    .emptiness: "虚",
    .bond: "娄",
    .net: "毕",
    .threeStars: "参",
    .extendedNet: "张",
    .chariot: "轸",
  ]

  private static let englishNames: [LunarMansion: String] = [
    .horn: "Horn",
    .neck: "Neck",
    .root: "Root",
    .room: "Room",
    .heart: "Heart",
    .tail: "Tail",
    .winnowingBasket: "Winnowing Basket",
    .dipper: "Dipper",
    .ox: "Ox",
    .girl: "Girl",
    .emptiness: "Emptiness",
    .rooftop: "Rooftop",
    .encampment: "Encampment",
    .wall: "Wall",
    .legs: "Legs",
    .bond: "Bond",
    .stomach: "Stomach",
    .pleiades: "Hairy Head",
    .net: "Net",
    .turtleBeak: "Turtle Beak",
    .threeStars: "Three Stars",
    .well: "Well",
    .ghost: "Ghost",
    .willow: "Willow",
    .star: "Star",
    .extendedNet: "Extended Net",
    .wings: "Wings",
    .chariot: "Chariot",
  ]
}

// MARK: - FourSymbol + LocalizedNaming

extension FourSymbol: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant:
      return traditionalChineseName
    case .zhHans:
      return self == .azureDragon ? "青龙" : traditionalChineseName
    case .en:
      switch self {
      case .azureDragon: return "Azure Dragon"
      case .vermilionBird: return "Vermilion Bird"
      case .whiteTiger: return "White Tiger"
      case .blackTortoise: return "Black Tortoise"
      }
    }
  }
}
