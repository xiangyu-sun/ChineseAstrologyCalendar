import Foundation

extension Jieqi: LocalizedNaming {
  public func localizedName(in language: DisplayLanguage) -> String {
    switch language {
    case .zhHant: return chineseName
    case .zhHans: return Self.simplifiedNames[self] ?? chineseName
    case .en: return Self.englishNames[self] ?? chineseName
    }
  }

  private static let simplifiedNames: [Jieqi: String] = [
    .startOfSpring: "立春",
    .rainWater: "雨水",
    .awakeningOfInsects: "惊蛰",
    .springEquinox: "春分",
    .clearAndBright: "清明",
    .grainRain: "谷雨",
    .startOfSummer: "立夏",
    .grainBuds: "小满",
    .grainInEar: "芒种",
    .summerSolstice: "夏至",
    .minorHeat: "小暑",
    .majorHeat: "大暑",
    .startOfAutumn: "立秋",
    .endOfHeat: "处暑",
    .whiteDew: "白露",
    .autumnEquinox: "秋分",
    .coldDew: "寒露",
    .frostDescent: "霜降",
    .startOfWinter: "立冬",
    .minorSnow: "小雪",
    .majorSnow: "大雪",
    .winterSolstice: "冬至",
    .minorCold: "小寒",
    .majorCold: "大寒",
  ]

  private static let englishNames: [Jieqi: String] = [
    .startOfSpring: "Start of Spring",
    .rainWater: "Rain Water",
    .awakeningOfInsects: "Awakening of Insects",
    .springEquinox: "Spring Equinox",
    .clearAndBright: "Qingming",
    .grainRain: "Grain Rain",
    .startOfSummer: "Start of Summer",
    .grainBuds: "Grain Buds",
    .grainInEar: "Grain in Ear",
    .summerSolstice: "Summer Solstice",
    .minorHeat: "Minor Heat",
    .majorHeat: "Major Heat",
    .startOfAutumn: "Start of Autumn",
    .endOfHeat: "End of Heat",
    .whiteDew: "White Dew",
    .autumnEquinox: "Autumn Equinox",
    .coldDew: "Cold Dew",
    .frostDescent: "Frost's Descent",
    .startOfWinter: "Start of Winter",
    .minorSnow: "Minor Snow",
    .majorSnow: "Major Snow",
    .winterSolstice: "Winter Solstice",
    .minorCold: "Minor Cold",
    .majorCold: "Major Cold",
  ]
}
