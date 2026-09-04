import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct LocalizationTests {

  // MARK: - DisplayLanguage locale detection

  @Test func localeDetectionSimplified() {
    #expect(DisplayLanguage(locale: Locale(identifier: "zh_Hans")) == .zhHans)
    #expect(DisplayLanguage(locale: Locale(identifier: "zh_CN")) == .zhHans)
    #expect(DisplayLanguage(locale: Locale(identifier: "zh_SG")) == .zhHans)
    #expect(DisplayLanguage(locale: Locale(identifier: "zh")) == .zhHans)
  }

  @Test func localeDetectionTraditional() {
    #expect(DisplayLanguage(locale: Locale(identifier: "zh_Hant")) == .zhHant)
    #expect(DisplayLanguage(locale: Locale(identifier: "zh_TW")) == .zhHant)
    #expect(DisplayLanguage(locale: Locale(identifier: "zh_HK")) == .zhHant)
    #expect(DisplayLanguage(locale: Locale(identifier: "zh_MO")) == .zhHant)
    #expect(DisplayLanguage(locale: Locale(identifier: "zh-Hant-TW")) == .zhHant)
  }

  @Test func localeDetectionEnglishFallback() {
    #expect(DisplayLanguage(locale: Locale(identifier: "en_US")) == .en)
    #expect(DisplayLanguage(locale: Locale(identifier: "fr_FR")) == .en)
    #expect(DisplayLanguage(locale: Locale(identifier: "ja_JP")) == .en)
  }

  // MARK: - Zodiac

  @Test func zodiacLocalized() {
    #expect(Zodiac.dragon.localizedName(in: .zhHant) == "龍")
    #expect(Zodiac.dragon.localizedName(in: .zhHans) == "龙")
    #expect(Zodiac.dragon.localizedName(in: .en) == "Dragon")
    // A character identical in both scripts falls through to Traditional.
    #expect(Zodiac.rat.localizedName(in: .zhHans) == "鼠")
    #expect(Zodiac.pig.localizedName(in: .en) == "Pig")
  }

  // MARK: - Wuxing

  @Test func wuxingLocalized() {
    #expect(Wuxing.metal.localizedName(in: .en) == "Metal")
    #expect(Wuxing.water.localizedName(in: .zhHans) == "水") // identical script
    #expect(Wuxing.earth.localizedColorDescription(in: .en) == "Yellow")
    #expect(Wuxing.earth.localizedColorDescription(in: .zhHans) == "黄")
    #expect(Wuxing.earth.localizedColorDescription(in: .zhHant) == "黃")
    #expect(Wuxing.water.localizedFlavor(in: .en) == "Salty")
    #expect(Wuxing.water.localizedFlavor(in: .zhHans) == "咸")
    #expect(Wuxing.water.localizedFlavor(in: .zhHant) == "鹹")
  }

  // MARK: - Season / FangWei

  @Test func seasonLocalized() {
    #expect(Season.spring.localizedName(in: .en) == "Spring")
    #expect(Season.fall.localizedName(in: .en) == "Autumn")
    #expect(Season.winter.localizedName(in: .zhHant) == "冬")
  }

  @Test func fangWeiLocalized() {
    #expect(FangWei.east.localizedName(in: .en) == "East")
    #expect(FangWei.east.localizedName(in: .zhHans) == "东")
    #expect(FangWei.east.localizedName(in: .zhHant) == "東")
    #expect(FangWei.center.localizedName(in: .en) == "Center")
  }

  // MARK: - TwelveGods

  @Test func twelveGodsLocalized() {
    #expect(TwelveGods.fullness.localizedName(in: .en) == "Fullness")
    #expect(TwelveGods.fullness.localizedName(in: .zhHans) == "满")
    #expect(TwelveGods.fullness.localizedName(in: .zhHant) == "滿")
    // Almanac prose stays Traditional Chinese regardless of language request.
    #expect(!TwelveGods.establish.meaning.isEmpty)
  }

  // MARK: - MoonPhase

  @Test func moonPhaseLocalized() {
    #expect(ChineseMoonPhase.fullMoon.localizedName(in: .en) == "Full Moon")
    #expect(ChineseMoonPhase.fullMoon.localizedName(in: .zhHans) == "满月")
    #expect(ChineseMoonPhase.fullMoon.localizedName(in: .zhHant) == "滿月")
    // The ancient rawValue name is canonical and untouched.
    #expect(ChineseMoonPhase.fullMoon.rawValue == "望")
  }

  // MARK: - Jieqi / Festival

  @Test func jieqiLocalized() {
    #expect(Jieqi.clearAndBright.localizedName(in: .en) == "Qingming")
    #expect(Jieqi.awakeningOfInsects.localizedName(in: .zhHans) == "惊蛰")
    #expect(Jieqi.awakeningOfInsects.localizedName(in: .zhHant) == "驚蟄")
  }

  @Test func festivalLocalized() {
    #expect(ChineseFestival.midAutumn.localizedName(in: .en) == "Mid-Autumn Festival")
    #expect(ChineseFestival.springFestival.localizedName(in: .zhHans) == "春节")
    #expect(ChineseFestival.springFestival.localizedName(in: .zhHant) == "春節")
  }

  // MARK: - Providers

  @Test func festivalProviderDelegatesToLocalizedName() {
    let en = LocalizedFestivalContentProvider(language: .en)
    #expect(en.name(for: .midAutumn) == "Mid-Autumn Festival")
    #expect(en.category == "Festival")
    let hans = LocalizedFestivalContentProvider(language: .zhHans)
    #expect(hans.category == "节日")
    // zhHant provider matches the default source category exactly.
    let hant = LocalizedFestivalContentProvider(language: .zhHant)
    #expect(hant.category == FestivalSource.categoryName)
    #expect(hant.name(for: .midAutumn) == ChineseFestival.midAutumn.chineseName)
  }

  @Test func jieqiProviderDelegatesToLocalizedName() {
    let en = LocalizedJieqiContentProvider(language: .en)
    #expect(en.name(for: .clearAndBright) == "Qingming")
    #expect(en.category == "Solar Term")
    // detail is intentionally the untranslated TCM health tip.
    #expect(en.detail(for: .clearAndBright) == Jieqi.clearAndBright.healthTip)
  }

  // MARK: - Backward compatibility

  @Test func defaultProvidersUnchanged() {
    let fest = DefaultFestivalContentProvider()
    #expect(fest.name(for: .midAutumn) == ChineseFestival.midAutumn.chineseName)
    #expect(fest.detail(for: .midAutumn) == ChineseFestival.midAutumn.meaning)
    let jieqi = DefaultJieqiContentProvider()
    #expect(jieqi.name(for: .clearAndBright) == Jieqi.clearAndBright.chineseName)
  }

  // MARK: - SpecialDayKind

  @Test func specialDayKindStableAcrossLanguages() {
    let today = Date()
    // Regardless of provider language, the kind is stable and locale-independent.
    let enSource = FestivalSource(contentProvider: LocalizedFestivalContentProvider(language: .en))
    let hantSource = FestivalSource(contentProvider: DefaultFestivalContentProvider())
    if let next = enSource.nextSpecialDay(after: today) {
      #expect(next.kind == .festival)
    }
    if let next = hantSource.nextSpecialDay(after: today) {
      #expect(next.kind == .festival)
    }
    let jieqiNext = JieqiSource().nextSpecialDay(after: today)
    #expect(jieqiNext?.kind == .jieqi)
  }

  @Test func specialDayDefaultKindIsCustom() {
    let day = SpecialDay(name: "x", category: "y", detail: "z", date: Date())
    #expect(day.kind == .custom)
  }

  // MARK: - Pinyin

  @Test func stemBranchPinyin() {
    #expect(Tiangan.kui.pinyin == "guǐ")
    #expect(Dizhi.mao.pinyin == "mǎo")
    let ganzhi = Ganzhi(gan: .kui, zhi: .mao)
    #expect(ganzhi.pinyin == "Guǐmǎo")
  }

  // MARK: - Bazi

  @Test func baziLocalizedFormatting() {
    let bazi = Bazi(
      nian: Ganzhi(gan: .kui, zhi: .mao),
      yue: Ganzhi(gan: .wu, zhi: .wu),
      ri: Ganzhi(gan: .xin, zhi: .si),
      shi: Ganzhi(gan: .kui, zhi: .chou))
    #expect(bazi.localizedFormattedDescription(in: .zhHant) == "年:癸卯 月:戊午 日:辛巳 時:癸丑")
    #expect(bazi.localizedFormattedDescription(in: .zhHans).contains("时:癸丑"))
    let en = bazi.localizedFormattedDescription(in: .en)
    #expect(en.contains("Year: Guǐmǎo (癸卯)"))
    #expect(en.contains("Hour: Guǐchǒu (癸丑)"))
  }

  // MARK: - Day / EventModel

  @Test func dayLocalized() {
    #expect(Day.day1.localizedName(in: .en) == "1st")
    #expect(Day.day2.localizedName(in: .en) == "2nd")
    #expect(Day.day3.localizedName(in: .en) == "3rd")
    #expect(Day.day11.localizedName(in: .en) == "11th")
    #expect(Day.day21.localizedName(in: .en) == "21st")
    #expect(Day.day30.localizedName(in: .en) == "30th")
    #expect(Day.day1.localizedName(in: .zhHant) == "初一")
    #expect(Day.day1.localizedName(in: .zhHans) == "初一")
  }

  @Test func eventModelLocalizedTitle() {
    let components = DateComponents(month: 1, day: 1)
    let event = EventModel(date: Date(), name: .day1, dateComponents: components)
    #expect(event.localizedTitle(in: .en) == "Month 1, 1st")
    #expect(event.localizedTitle(in: .zhHant).contains("初一"))
  }
}
