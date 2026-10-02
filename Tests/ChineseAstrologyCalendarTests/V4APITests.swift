import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct DisplayLanguageV4Tests {

  @Test func builtInIdentifiers() {
    #expect(DisplayLanguage.allCases.map(\.identifier) == ["zh-Hant", "zh-Hans", "en", "ru", "es"])
  }

  @Test func resolvesRussianAndSpanishInAnyRegion() {
    #expect(DisplayLanguage(identifier: "ru-RU") == .ru)
    #expect(DisplayLanguage(identifier: "es_MX") == .es)
    #expect(DisplayLanguage(identifier: "es-419") == .es)
    #expect(DisplayLanguage(identifier: "ja") == .en)
  }

  @Test func codableUsesIdentifier() throws {
    let data = try JSONEncoder().encode([DisplayLanguage.zhHans, .ru])
    #expect(String(decoding: data, as: UTF8.self) == #"["zh-Hans","ru"]"#)
    #expect(try JSONDecoder().decode([DisplayLanguage].self, from: data) == [.zhHans, .ru])
  }

  @Test func untranslatedTypesFallBackToEnglish() {
    #expect(Zodiac.dragon.localizedName(in: .ru) == "Dragon")
    #expect(LunarMonth(number: 1)?.localizedName(in: .es) == "1st Month")
  }

  @Test func festivalsAndSolarTermsAreTranslated() {
    #expect(ChineseFestival.midAutumn.localizedName(in: .ru) == RussianFestivalContent().name(for: .midAutumn))
    #expect(ChineseFestival.midAutumn.localizedName(in: .es) != ChineseFestival.midAutumn.localizedName(in: .en))
    #expect(Jieqi.winterSolstice.localizedName(in: .es) == "Solsticio de invierno")
    #expect(LocalizedJieqiContentProvider(language: .ru).detail(for: .startOfSpring) != Jieqi.startOfSpring.healthTip)
    #expect(LocalizedJieqiContentProvider(language: .en).detail(for: .startOfSpring) == Jieqi.startOfSpring.healthTip)
  }

  @Test func everyLanguageRendersEveryFestivalAndJieqi() {
    for language in DisplayLanguage.allCases {
      for festival in ChineseFestival.allCases {
        #expect(!festival.localizedName(in: language).isEmpty)
      }
      for jieqi in Jieqi.allCases {
        #expect(!jieqi.localizedName(in: language).isEmpty)
      }
    }
  }
}

@Suite struct LunarDateTests {

  private func cstNoon(_ year: Int, _ month: Int, _ day: Int) -> Date {
    var gregorian = Calendar(identifier: .gregorian)
    gregorian.timeZone = .chinaStandardTime
    return gregorian.date(from: DateComponents(year: year, month: month, day: day, hour: 12))!
  }

  @Test func chineseNewYear2024() throws {
    let lunar = try #require(LunarDate(date: cstNoon(2024, 2, 10), calendar: .chineseCalendarGTM8))
    #expect(lunar.year.description == "甲辰")
    #expect(lunar.zodiac == .dragon)
    #expect(lunar.month == LunarMonth(number: 1))
    #expect(lunar.day == .day1)
    #expect(lunar.formatted(.yearZodiacMonthDay, in: .zhHant) == "甲辰龍年正月初一")
    #expect(lunar.formatted(.yearZodiacMonthDay, in: .zhHans) == "甲辰龙年正月初一")
    #expect(lunar.formatted(.yearZodiacMonthDay, in: .en) == "1st Month 1st, Year of the Dragon (Jiǎchén)")
    #expect(lunar.formatted(.yearMonthDay, in: .en) == "1st Month 1st, Jiǎchén year")
    #expect(lunar.formatted(.monthDay, in: .zhHant) == "正月初一")
    #expect(lunar.formatted(.day, in: .zhHant) == "初一")
    #expect(lunar.description == "甲辰年正月初一")
  }

  @Test func leapMonth() throws {
    // 2023-03-22 is the first day of 閏二月 in the 癸卯 year.
    let lunar = try #require(cstNoon(2023, 3, 22).lunarDate(.chineseCalendarGTM8))
    #expect(lunar.formatted(.yearMonthDay, in: .zhHant) == "癸卯年閏二月初一")
    #expect(lunar.formatted(.monthDay, in: .zhHans) == "闰二月初一")
  }

  @Test func lateMonthsUseTraditionalNames() throws {
    // 2025-01-10 is 臘月十一 in the 甲辰 year.
    let lunar = try #require(cstNoon(2025, 1, 10).lunarDate(.chineseCalendarGTM8))
    #expect(lunar.formatted(.monthDay, in: .zhHant) == "臘月十一")
  }
}

@Suite struct ChineseAlmanacTests {

  private let almanac = ChineseAlmanac(language: .en)

  private func cstNoon(_ year: Int, _ month: Int, _ day: Int) -> Date {
    var gregorian = Calendar(identifier: .gregorian)
    gregorian.timeZone = .chinaStandardTime
    return gregorian.date(from: DateComponents(year: year, month: month, day: day, hour: 12))!
  }

  @Test func springFestival() {
    let day = almanac.day(for: cstNoon(2024, 2, 10))
    #expect(day.festival == .springFestival)
    #expect(day.zodiac == .dragon)
    #expect(day.moonPhase == Day.day1.moonPhase)
    #expect(day.shichen.dizhi == .wu)
    #expect(day.text.festival == "Spring Festival")
    #expect(day.text.shichen == "Wǔ hour")
    #expect(day.text.lunarDate == "1st Month 1st, Year of the Dragon (Jiǎchén)")
  }

  @Test func midAutumn() {
    let day = ChineseAlmanac(language: .zhHant).day(for: cstNoon(2024, 9, 17))
    #expect(day.festival == .midAutumn)
    #expect(day.text.lunarMonthDay == "八月十五")
    #expect(day.text.festival == "中秋節")
  }

  @Test func solarTermDay() {
    let day = almanac.day(for: cstNoon(2025, 4, 4))
    #expect(day.jieqi?.jieqi == .clearAndBright)
    #expect(day.isJieqiDay)
    #expect(!almanac.day(for: cstNoon(2025, 4, 6)).isJieqiDay)
  }

  @Test func lunarDayIsTakenInTheAlmanacTimeZone() {
    // 23:30 on 2024-02-09 in Los Angeles is already 2024-02-10 (New Year) in Beijing.
    let instant = cstNoon(2024, 2, 10).addingTimeInterval(-4.5 * 3600)
    let beijing = ChineseAlmanac(language: .en).day(for: instant)
    let losAngeles = ChineseAlmanac(timeZone: TimeZone(identifier: "America/Los_Angeles")!, language: .en)
      .day(for: instant)
    #expect(beijing.lunarDate?.day == .day1)
    #expect(losAngeles.lunarDate?.day == .day30 || losAngeles.lunarDate?.day == .day29)
  }

  @Test func daysSamplesConsecutiveDays() {
    let days = almanac.days(from: cstNoon(2024, 2, 9), count: 3)
    #expect(days.count == 3)
    #expect(days[1].festival == .springFestival)
    #expect(days.map { $0.lunarDate?.month.number } == [12, 1, 1])
  }

  @Test func everyLanguageRendersText() {
    for language in DisplayLanguage.allCases {
      let text = ChineseAlmanac(language: language).day(for: cstNoon(2024, 9, 17)).text
      #expect(text.lunarDate?.isEmpty == false)
      #expect(text.festival?.isEmpty == false)
      #expect(!text.lunarMansion.isEmpty)
    }
  }
}

@Suite struct JieqiCivilDayTests {

  private func cst(_ year: Int, _ month: Int, _ day: Int, _ hour: Int = 0) -> Date {
    var gregorian = Calendar(identifier: .gregorian)
    gregorian.timeZone = .chinaStandardTime
    return gregorian.date(from: DateComponents(year: year, month: month, day: day, hour: hour))!
  }

  /// Terms that begin in the afternoon belong to that civil day, not the next.
  /// Regression: sampling at noon moved them a day late.
  @Test func afternoonTransitionsCountForTheirOwnDay() {
    // 清明 2025 begins 15:48 on April 4; 雨水 2025 begins 12:07 on February 18.
    #expect(cst(2025, 4, 4).isJieqiDay)
    #expect(cst(2025, 4, 4).jieqi == .clearAndBright)
    #expect(!cst(2025, 4, 5).isJieqiDay)
    #expect(cst(2025, 2, 18, 1).jieqi == .rainWater)
    #expect(cst(2025, 2, 17, 23).jieqi == .startOfSpring)
  }

  @Test func concurrentLunarConversionIsConsistent() async {
    let dates = (0..<200).map { cst(2024, 1, 1).addingTimeInterval(Double($0) * 86_400) }
    let expected = dates.map { $0.lunarDate(.chineseCalendarGTM8) }
    let results = await withTaskGroup(of: (Int, LunarDate?).self) { group in
      for (index, date) in dates.enumerated() {
        group.addTask {
          var calendar = Calendar(identifier: .chinese)
          // Alternate time zones so racing callers would corrupt each other.
          calendar.timeZone = index.isMultiple(of: 2) ? .chinaStandardTime : TimeZone(identifier: "America/Los_Angeles")!
          _ = date.lunarDate(calendar)
          return (index, date.lunarDate(.chineseCalendarGTM8))
        }
      }
      var collected = [LunarDate?](repeating: nil, count: dates.count)
      for await (index, value) in group { collected[index] = value }
      return collected
    }
    #expect(results == expected)
  }
}
