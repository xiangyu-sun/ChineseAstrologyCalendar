import Foundation

// MARK: - LocalizedFestivalContentProvider

/// A `ChineseFestivalContentProvider` that supplies Simplified Chinese or
/// English display strings for ``ChineseFestival``.
///
/// The library's canonical data (`chineseName`, `meaning`) is Traditional
/// Chinese; this provider translates it for the requested ``DisplayLanguage``.
/// `.zhHant` returns the same values as `DefaultFestivalContentProvider`.
///
/// ```swift
/// let source = FestivalSource(contentProvider: LocalizedFestivalContentProvider(language: .en))
/// ```
public struct LocalizedFestivalContentProvider: ChineseFestivalContentProvider {

  public let language: DisplayLanguage

  public init(language: DisplayLanguage) {
    self.language = language
  }

  public func name(for festival: ChineseFestival) -> String {
    festival.localizedName(in: language)
  }

  public func detail(for festival: ChineseFestival) -> String {
    switch language {
    case .zhHant: return festival.meaning
    case .zhHans: return Self.simplifiedMeanings[festival] ?? festival.meaning
    case .en: return Self.englishMeanings[festival] ?? festival.meaning
    }
  }

  public var category: String {
    switch language {
    case .zhHant: return FestivalSource.categoryName
    case .zhHans: return "节日"
    case .en: return "Festival"
    }
  }

  // MARK: Private — Simplified Chinese

  private static let simplifiedMeanings: [ChineseFestival: String] = [
    .springFestival: "农历新年，一年中最重要的传统节日，庆祝新年的开始。",
    .lanternFestival: "正月十五，观赏花灯、猜灯谜，象征新年节庆的结束。",
    .dragonRaisesHead: "二月初二，传说龙王抬头，为农耕季节的开始。",
    .qingming: "扫墓祭祖，缅怀先人，也是踏青郊游的节日。",
    .dragonBoat: "五月初五，赛龙舟、吃粽子，纪念爱国诗人屈原。",
    .doubleSeventhNight: "七月初七，牛郎织女相会的日子，中国的情人节。",
    .ghostFestival: "七月十五，祭祀祖先亡魂，民间称鬼节或盂兰盆节。",
    .midAutumn: "八月十五，赏月、吃月饼，象征家人团圆。",
    .doubleNinth: "九月初九，登高远望、佩茱萸，也是敬老节。",
    .dongzhi: "冬至，一年中夜最长的一天，家人聚在一起吃汤圆。",
    .laba: "腊月初八，喝腊八粥，祈求新年丰收平安。",
    .littleNewYear: "腊月廿三，祭灶王爷，准备过年的开始。",
  ]

  // MARK: Private — English

  private static let englishMeanings: [ChineseFestival: String] = [
    .springFestival: "Chinese New Year — the most important traditional festival, celebrating the start of the lunar year.",
    .lanternFestival: "The 15th day of the first lunar month; lantern viewing and riddle-guessing mark the end of New Year celebrations.",
    .dragonRaisesHead: "The 2nd day of the second lunar month, traditionally when the Dragon King raises its head, marking the start of the farming season.",
    .qingming: "Tomb-sweeping day for honoring ancestors, also a traditional occasion for spring outings.",
    .dragonBoat: "The 5th day of the fifth lunar month; dragon boat races and zongzi commemorate the poet Qu Yuan.",
    .doubleSeventhNight: "The 7th day of the seventh lunar month, marking the reunion of the Cowherd and Weaver Girl — China's Valentine's Day.",
    .ghostFestival: "The 15th day of the seventh lunar month, when offerings are made to ancestral spirits.",
    .midAutumn: "The 15th day of the eighth lunar month; moon-viewing and mooncakes symbolize family reunion.",
    .doubleNinth: "The 9th day of the ninth lunar month; climbing heights and wearing dogwood also honor the elderly.",
    .dongzhi: "The longest night of the year, when families gather to eat tangyuan.",
    .laba: "The 8th day of the twelfth lunar month; Laba congee is eaten to pray for a bountiful new year.",
    .littleNewYear: "The 23rd day of the twelfth lunar month, when the Kitchen God is honored ahead of the New Year.",
  ]
}
