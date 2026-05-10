import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct SpecialDayTests {

  private var utcCalendar: Calendar {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(identifier: "UTC")!
    return cal
  }

  private func date(year: Int, month: Int, day: Int) -> Date {
    utcCalendar.date(from: DateComponents(year: year, month: month, day: day))!
  }

  // MARK: - FestivalSource

  @Test func festivalSourceDetectsSpringFestival() {
    // Spring Festival 2025 = Jan 29 UTC
    let springFestival2025 = date(year: 2025, month: 1, day: 29)
    let results = springFestival2025.specialDays(sources: [FestivalSource()])
    #expect(results.count == 1)
    #expect(results[0].name == "春節")
    #expect(results[0].category == FestivalSource.categoryName)
    #expect(!results[0].detail.isEmpty)
  }

  @Test func festivalSourceEmptyOnOrdinaryDay() {
    // Feb 15 2025 is not a festival
    let ordinary = date(year: 2025, month: 2, day: 15)
    let results = ordinary.specialDays(sources: [FestivalSource()])
    #expect(results.isEmpty)
  }

  // MARK: - JieqiSource

  @Test func jieqiSourceDetectsQingming() {
    // Qingming 2025 = April 5 UTC (isJieqiDay == true)
    let qingming2025 = date(year: 2025, month: 4, day: 5)
    let results = qingming2025.specialDays(sources: [JieqiSource()])
    #expect(results.count == 1)
    #expect(results[0].name == "清明")
    #expect(results[0].category == JieqiSource.categoryName)
    #expect(!results[0].detail.isEmpty)
  }

  @Test func jieqiSourceEmptyOnNonTransitionDay() {
    // April 6 is within the Qingming period but not the transition day
    let inPeriod = date(year: 2025, month: 4, day: 6)
    let results = inPeriod.specialDays(sources: [JieqiSource()])
    #expect(results.isEmpty)
  }

  // MARK: - Both sources together (Qingming = festival + jieqi)

  @Test func qingmingAppearsFromBothSources() {
    // April 5 2025: both a ChineseFestival and a Jieqi transition
    let qingming2025 = date(year: 2025, month: 4, day: 5)
    let results = qingming2025.specialDays(sources: [FestivalSource(), JieqiSource()])
    #expect(results.count == 2)
    let categories = Set(results.map(\.category))
    #expect(categories.contains(FestivalSource.categoryName))
    #expect(categories.contains(JieqiSource.categoryName))
  }

  // MARK: - nextChineseFestival

  @Test func nextChineseFestivalReturnsUpcomingFestival() {
    // Feb 15 2025: Lantern Festival (元宵節) already passed (Feb 12).
    // Next festival is Dragon Raises Head (龍抬頭) on lunar 二月初二.
    let ordinary = date(year: 2025, month: 2, day: 15)
    let result = ordinary.nextChineseFestival()
    #expect(result != nil)
    #expect(result!.date > ordinary)
  }

  @Test func nextChineseFestivalOnFestivalDayReturnsSelf() {
    // Spring Festival 2025 = Jan 29
    let springFestival2025 = date(year: 2025, month: 1, day: 29)
    let result = springFestival2025.nextChineseFestival()
    #expect(result?.festival == .springFestival)
    #expect(result?.date == springFestival2025)
  }

  // MARK: - nextSpecialDay

  @Test func nextSpecialDayFromOrdinaryDateIsInFuture() {
    // Feb 15 2025 is ordinary; next event should be Rainwater (雨水) in 4 days
    let ordinary = date(year: 2025, month: 2, day: 15)
    let result = ordinary.nextSpecialDay(sources: [FestivalSource(), JieqiSource()])
    #expect(result != nil)
    #expect(result!.daysUntil > 0)
    #expect(result!.day.date > ordinary)
  }

  @Test func nextSpecialDayPicksSoonest() {
    // Feb 15 2025: Rainwater (雨水 jieqi, Feb 19) should beat Lantern Festival (元宵節, Feb 12 — already past)
    // Actually Lantern Festival 2025 is Feb 12 which is before our date.
    // Rainwater is Feb 19 (4 days away). Verify it is returned.
    let ordinary = date(year: 2025, month: 2, day: 15)
    let result = ordinary.nextSpecialDay(sources: [FestivalSource(), JieqiSource()])
    #expect(result?.day.name == "雨水")
    #expect(result?.daysUntil == 4)
  }

  // MARK: - Pluggable custom source

  @Test func customSourcePlugsInAlongsideBuiltIns() {
    // Define a minimal custom source that marks Jan 1 as "元旦"
    struct GregorianNewYearSource: SpecialDaySource {
      func specialDays(on date: Date) -> [SpecialDay] {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        let comps = cal.dateComponents([.month, .day], from: date)
        guard comps.month == 1, comps.day == 1 else { return [] }
        return [SpecialDay(name: "元旦", category: "公曆節日", detail: "陽曆新年", date: date)]
      }
      func nextSpecialDay(after date: Date) -> SpecialDay? { nil }
    }

    let jan1_2026 = utcCalendar.date(from: DateComponents(year: 2026, month: 1, day: 1))!
    let sources: [SpecialDaySource] = [FestivalSource(), JieqiSource(), GregorianNewYearSource()]
    let results = jan1_2026.specialDays(sources: sources)

    // Jan 1 is not a Chinese festival or jieqi transition — only the custom source fires
    let customResult = results.first { $0.category == "公曆節日" }
    #expect(customResult != nil)
    #expect(customResult?.name == "元旦")
  }

  @Test func customSourceCombinesWithBuiltInsOnSameDay() {
    // A custom source that marks every Spring Festival day as something extra
    struct ExtraSpringSource: SpecialDaySource {
      func specialDays(on date: Date) -> [SpecialDay] {
        guard date.chineseFestival == .springFestival else { return [] }
        return [SpecialDay(name: "新年快樂", category: "自定義", detail: "Happy New Year!", date: date)]
      }
      func nextSpecialDay(after date: Date) -> SpecialDay? { nil }
    }

    let springFestival2025 = date(year: 2025, month: 1, day: 29)
    let sources: [SpecialDaySource] = [FestivalSource(), ExtraSpringSource()]
    let results = springFestival2025.specialDays(sources: sources)
    #expect(results.count == 2)
    let names = results.map(\.name)
    #expect(names.contains("春節"))
    #expect(names.contains("新年快樂"))
  }
}
