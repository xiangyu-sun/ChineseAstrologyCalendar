import Foundation

extension ChineseFestival: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language {
    case .zhHant: return chineseName
    case .zhHans: return Self.simplifiedNames[self] ?? chineseName
    case .en: return Self.englishNames[self] ?? chineseName
    }
  }

  private static let simplifiedNames: [ChineseFestival: String] = [
    .springFestival: "春节",
    .lanternFestival: "元宵节",
    .dragonRaisesHead: "龙抬头",
    .qingming: "清明节",
    .dragonBoat: "端午节",
    .doubleSeventhNight: "七夕",
    .ghostFestival: "中元节",
    .midAutumn: "中秋节",
    .doubleNinth: "重阳节",
    .dongzhi: "冬至",
    .laba: "腊八节",
    .littleNewYear: "小年",
  ]

  private static let englishNames: [ChineseFestival: String] = [
    .springFestival: "Spring Festival",
    .lanternFestival: "Lantern Festival",
    .dragonRaisesHead: "Dragon Raises Head Festival",
    .qingming: "Qingming Festival",
    .dragonBoat: "Dragon Boat Festival",
    .doubleSeventhNight: "Qixi Festival",
    .ghostFestival: "Ghost Festival",
    .midAutumn: "Mid-Autumn Festival",
    .doubleNinth: "Double Ninth Festival",
    .dongzhi: "Winter Solstice",
    .laba: "Laba Festival",
    .littleNewYear: "Little New Year",
  ]
}
