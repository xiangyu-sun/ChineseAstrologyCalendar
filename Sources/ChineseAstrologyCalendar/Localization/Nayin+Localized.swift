import Foundation

extension Nayin: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language.base {
    case .zhHant: return traditionalChineseName
    case .zhHans: return Self.simplifiedNames[self] ?? traditionalChineseName
    case .en: return Self.englishNames[self] ?? traditionalChineseName
    }
  }

  // Names not listed are identical in both scripts.
  private static let simplifiedNames: [Nayin: String] = [
    .furnaceFire: "炉中火",
    .swordEdgeMetal: "剑锋金",
    .mountaintopFire: "山头火",
    .ravineWater: "涧下水",
    .rampartEarth: "城头土",
    .beeswaxMetal: "白蜡金",
    .willowWood: "杨柳木",
    .thunderFire: "霹雳火",
    .longRiverWater: "长流水",
    .lanternFire: "覆灯火",
    .postRoadEarth: "大驿土",
    .braceletMetal: "钗钏金",
  ]

  private static let englishNames: [Nayin: String] = [
    .seaGold: "Gold in the Sea",
    .furnaceFire: "Fire in the Furnace",
    .forestWood: "Wood of the Great Forest",
    .roadsideEarth: "Earth by the Roadside",
    .swordEdgeMetal: "Metal of the Sword Edge",
    .mountaintopFire: "Fire on the Mountaintop",
    .ravineWater: "Water in the Ravine",
    .rampartEarth: "Earth on the City Wall",
    .beeswaxMetal: "White Wax Metal",
    .willowWood: "Willow Wood",
    .springWater: "Water in the Spring",
    .rooftopEarth: "Earth on the Roof",
    .thunderFire: "Thunderbolt Fire",
    .pineWood: "Pine and Cypress Wood",
    .longRiverWater: "Long-Flowing Water",
    .sandGold: "Gold in the Sand",
    .footOfMountainFire: "Fire at the Foot of the Mountain",
    .flatlandWood: "Wood of the Flatland",
    .wallEarth: "Earth on the Wall",
    .goldLeafMetal: "Gold Leaf Metal",
    .lanternFire: "Lamp Fire",
    .celestialRiverWater: "Water of the Heavenly River",
    .postRoadEarth: "Earth of the Great Post Road",
    .braceletMetal: "Hairpin and Bracelet Gold",
    .mulberryWood: "Mulberry Wood",
    .streamWater: "Water of the Great Stream",
    .sandEarth: "Earth in the Sand",
    .heavenlyFire: "Fire in the Sky",
    .pomegranateWood: "Pomegranate Wood",
    .oceanWater: "Water of the Great Sea",
  ]
}
