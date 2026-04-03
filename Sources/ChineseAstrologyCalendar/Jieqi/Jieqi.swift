import Astral
import Foundation

// MARK: - Jieqi

/// 太陽位於黃經角度
public enum Jieqi: Int, CaseIterable, Equatable, TraditionalChineseNaming, Sendable {
  case springEquinox      = 0   // 春分
  case clearAndBright     = 1   // 清明
  case grainRain          = 2   // 穀雨

  case startOfSummer      = 3   // 立夏
  case grainBuds          = 4   // 小滿
  case grainInEar         = 5   // 芒種

  case summerSolstice     = 6   // 夏至
  case minorHeat          = 7   // 小暑
  case majorHeat          = 8   // 大暑

  case startOfAutumn      = 9   // 立秋
  case endOfHeat          = 10  // 處暑
  case whiteDew           = 11  // 白露

  case autumnEquinox      = 12  // 秋分
  case coldDew            = 13  // 寒露
  case frostDescent       = 14  // 霜降

  case startOfWinter      = 15  // 立冬
  case minorSnow          = 16  // 小雪
  case majorSnow          = 17  // 大雪

  case winterSolstice     = 18  // 冬至
  case minorCold          = 19  // 小寒
  case majorCold          = 20  // 大寒

  case startOfSpring      = 21  // 立春
  case rainWater          = 22  // 雨水
  case awakeningOfInsects = 23  // 驚蟄

  // MARK: Public


  /// Returns the case name as a String
  public var stringValue: String {
    return String(describing: self)
  }

  public static var current: Jieqi? {
    // Subtract 0.5 before flooring to undo the +7.5° rounding offset in
    // currentSolarTerm(), giving floor(normalizedLong / 15) — i.e. the
    // solar term period that most recently started, not the nearest one.
    self.init(rawValue: Int(floor(currentSolarTerm() - 0.5)))
  }

  public var qi: Bool {
    rawValue.isMultiple(of: 2)
  }

  public var celestialLongitude: Int {
    (15 * rawValue)
  }

  /// Returns the Gregorian month (1 = January … 12 = December) corresponding to this solar term's celestial longitude.
  /// Uses the convention that 0° Aries (spring equinox) maps to March.
  public var monthFromCelestialLongitude: Int {
      // Each solar term spans a 30° band; offset by 15° to center the band.
      // [0,30)→March, [30,60)→April, …, [330,360)→February.
      let index = (celestialLongitude + 15) / 30
      return ((index + 2) % 12) + 1
  }


  /// The next solar term in the 24-term cycle.
  public var next: Jieqi {
    Jieqi(rawValue: (rawValue + 1) % 24) ?? .springEquinox
  }

  public var jieqiPairs: [(jie: Jieqi, qi: Jieqi)] {
    (0..<12).map { base in
      let value = base * 2
      return (Jieqi(rawValue: value + 1) ?? .startOfSpring, Jieqi(rawValue: (value + 2) % 24) ?? .startOfSpring)
    }
  }
}

public extension Date {
  var jieqi: Jieqi? {
    let raw = Int(floor(currentSolarTerm(for: self) - 0.5))
    return Jieqi(rawValue: ((raw % 24) + 24) % 24)
  }
}

// MARK: DizhiConvertable

extension Jieqi: DizhiConvertable {
  public var dizhi: Dizhi? {
    Dizhi(rawValue: ((rawValue / 2 + 2) % 12) + 1)
  }
}

extension Jieqi {

  /// Traditional Chinese name for this solar term.
  public var chineseName: String {
    switch self {
    case .startOfSpring:
      return "立春"
    case .rainWater:
      return "雨水"
    case .awakeningOfInsects:
      return "驚蟄"
    case .springEquinox:
      return "春分"
    case .clearAndBright:
      return "清明"
    case .grainRain:
      return "穀雨"
    case .startOfSummer:
      return "立夏"
    case .grainBuds:
      return "小滿"
    case .grainInEar:
      return "芒種"
    case .summerSolstice:
      return "夏至"
    case .minorHeat:
      return "小暑"
    case .majorHeat:
      return "大暑"
    case .startOfAutumn:
      return "立秋"
    case .endOfHeat:
      return "處暑"
    case .whiteDew:
      return "白露"
    case .autumnEquinox:
      return "秋分"
    case .coldDew:
      return "寒露"
    case .frostDescent:
      return "霜降"
    case .startOfWinter:
      return "立冬"
    case .minorSnow:
      return "小雪"
    case .majorSnow:
      return "大雪"
    case .winterSolstice:
      return "冬至"
    case .minorCold:
      return "小寒"
    case .majorCold:
      return "大寒"
    }
  }

  /// Traditional Chinese name for this solar term.
  public var traditionalChineseName: String { chineseName }

  public var qishierHou: String {
    switch self {
    case .startOfSpring:
      return "立春之日東風解凍，又五日蟄蟲始振，又五日魚上冰（魚陟負冰)"
    case .rainWater:
      return "雨水之日獺祭魚，又五日鴻雁來（候雁北），又五日草木萌動"
    case .awakeningOfInsects:
      return "驚蟄之日桃始華，又五日倉庚鳴，又五日鷹化為鳩"
    case .springEquinox:
      return "春分之日玄鳥至，又五日雷乃發聲，又五日始電"
    case .clearAndBright:
      return "清明之日桐始華，又五日田鼠化為鴽，又五日虹始見"
    case .grainRain:
      return "穀雨之日萍始生，又五日鳴鳩拂其羽，又五日戴勝降于桑"
    case .startOfSummer:
      return "立夏之日螻蟈鳴，又五日蚯蚓出，又五日王瓜生"
    case .grainBuds:
      return "小滿之日苦菜秀，又五日靡草死，又五日小暑至（麥秋生，麥秋至)"
    case .grainInEar:
      return "芒種之日螳螂生，又五日鵙始鳴，又五日反舌無聲"
    case .summerSolstice:
      return "夏至之日鹿角解，又五日蜩始鳴，又五日半夏生"
    case .minorHeat:
      return "小暑之日溫風至，又五日蟋蟀居壁，又五日鷹乃學習（鷹始擊）"
    case .majorHeat:
      return "大暑之日腐草為螢，又五日土潤溽暑，又五日大雨時行"
    case .startOfAutumn:
      return "立秋之日涼風至，又五日白露降，又五日寒蟬鳴"
    case .endOfHeat:
      return "處暑之日鷹乃祭鳥，又五日天地始肅，又五日禾乃登"
    case .whiteDew:
      return "白露之日鴻雁來，又五日玄鳥歸，又五日群鳥養羞"
    case .autumnEquinox:
      return "秋分之日雷始收聲，又五日蟄蟲培坯戶，又五日水始涸"
    case .coldDew:
      return "寒露之日鴻雁來賓，又五日雀入大水為蛤，又五日菊有黃華"
    case .frostDescent:
      return "霜降之日豺乃祭獸，又五日草木黃落，又五日蟄蟲咸俯"
    case .startOfWinter:
      return "立冬之日水始冰，又五日地始凍，又五日雉入大水為蜃"
    case .minorSnow:
      return "小雪之日虹藏不見，又五日天氣上騰地氣下降，又五日閉塞而成冬"
    case .majorSnow:
      return "大雪之日鶡旦不鳴，又五日虎始交，又五日荔挺生（荔挺出）"
    case .winterSolstice:
      return "冬至之日蚯蚓結，又五日麋角解，又五日水泉動"
    case .minorCold:
      return "小寒之日雁北鄉，又五日鵲始巢，又五日雉始鴝（雉始雊）"
    case .majorCold:
      return "大寒之日雞始乳，又五日鷲鳥厲疾（征鳥厲疾），又五日水澤腹堅"
    }
  }

}
