import Foundation

// MARK: - LunarMansion + LocalizedNaming

/// Chinese names include the 宿 suffix (角宿), matching ``LunarMansion/name``.
extension LunarMansion: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant: return name
    case .zhHans: return (Self.simplifiedCharacters[self] ?? rawValue) + "宿"
    case .en: return Self.englishNames[self] ?? name
    case .es: return Self.spanishNames[self] ?? name
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

  private static let spanishNames: [LunarMansion: String] = [
    .horn: "Cuerno",
    .neck: "Cuello",
    .root: "Raíz",
    .room: "Habitación",
    .heart: "Corazón",
    .tail: "Cola",
    .winnowingBasket: "Cesta de aventar",
    .dipper: "Cucharón",
    .ox: "Buey",
    .girl: "Muchacha",
    .emptiness: "Vacío",
    .rooftop: "Tejado",
    .encampment: "Campamento",
    .wall: "Muro",
    .legs: "Piernas",
    .bond: "Lazo",
    .stomach: "Estómago",
    .pleiades: "Cabeza peluda",
    .net: "Red",
    .turtleBeak: "Pico de tortuga",
    .threeStars: "Tres estrellas",
    .well: "Pozo",
    .ghost: "Fantasma",
    .willow: "Sauce",
    .star: "Estrella",
    .extendedNet: "Red extendida",
    .wings: "Alas",
    .chariot: "Carro",
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
    case .es:
      switch self {
      case .azureDragon: return "Dragón Azul"
      case .vermilionBird: return "Pájaro Bermellón"
      case .whiteTiger: return "Tigre Blanco"
      case .blackTortoise: return "Tortuga Negra"
      }
    }
  }
}
