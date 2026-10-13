import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct SpecialDayTimeZoneTests {

  private let losAngeles = TimeZone(identifier: "America/Los_Angeles")!

  private func calendar(_ timeZone: TimeZone) -> Calendar {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = timeZone
    return cal
  }

  private func date(_ year: Int, _ month: Int, _ day: Int, hour: Int = 12, in timeZone: TimeZone = .chinaStandardTime) -> Date {
    calendar(timeZone).date(from: DateComponents(year: year, month: month, day: day, hour: hour))!
  }

  private func days(in year: Int, timeZone: TimeZone) -> [Date] {
    (0..<365).map { calendar(timeZone).date(byAdding: .day, value: $0, to: date(year, 1, 1, in: timeZone))! }
  }

  // MARK: - JieqiSource(timeZone:)

  @Test func jieqiSourceFollowsItsTimeZone() {
    for tz in [TimeZone.chinaStandardTime, losAngeles] {
      let source = JieqiSource(timeZone: tz)
      for day in days(in: 2025, timeZone: tz) {
        #expect(source.specialDays(on: day).isEmpty == !day.isJieqiDay(in: tz))
      }
    }
  }

  @Test func jieqiSourceTimeZoneChangesTheDayForSomeTerms() {
    // At least one 2025 term starts on a different calendar day in Los Angeles,
    // otherwise the time-zone parameter would be untested.
    let china = Set(days(in: 2025, timeZone: .chinaStandardTime).filter { $0.isJieqiDay(in: .chinaStandardTime) }
      .map { calendar(.chinaStandardTime).dateComponents([.month, .day], from: $0) })
    let la = Set(days(in: 2025, timeZone: losAngeles).filter { $0.isJieqiDay(in: losAngeles) }
      .map { calendar(losAngeles).dateComponents([.month, .day], from: $0) })
    #expect(china != la)
  }

  @Test func jieqiSourceNextUsesItsTimeZone() {
    let start = date(2025, 3, 1, in: losAngeles)
    let next = JieqiSource(timeZone: losAngeles).nextSpecialDay(after: start)
    #expect(next?.date == start.nextJieqi(in: losAngeles)?.startDate)
  }

  @Test func jieqiSourceDefaultIsChinaTime() {
    let day = date(2025, 4, 4)
    #expect(JieqiSource().specialDays(on: day).map(\.name) == JieqiSource(timeZone: .chinaStandardTime).specialDays(on: day).map(\.name))
  }

  // MARK: - FestivalSource(timeZone:)

  @Test func festivalSourceFollowsItsTimeZone() {
    for tz in [TimeZone.chinaStandardTime, losAngeles] {
      var lunar = Calendar(identifier: .chinese)
      lunar.timeZone = tz
      let source = FestivalSource(converter: DayConverter(calendar: lunar), timeZone: tz)
      for day in days(in: 2025, timeZone: tz) {
        #expect(source.specialDays(on: day).isEmpty == (day.chineseFestival(timeZone: tz) == nil))
      }
    }
  }

  @Test func festivalSourceNextIsStrictlyAfterTheDay() {
    let source = FestivalSource(converter: DayConverter(calendar: .chineseCalendarGTM8), timeZone: .chinaStandardTime)
    let springFestival = date(2025, 1, 29)
    let next = source.nextSpecialDay(after: springFestival)
    #expect(next?.name == "元宵節")
  }

  @Test func timeZoneAwareNextDateFindsDongzhi() {
    let start = date(2025, 11, 1)
    let next = ChineseFestival.dongzhi.nextDate(from: start, converter: DayConverter(calendar: .chineseCalendarGTM8), timeZone: .chinaStandardTime)
    #expect(next.map { calendar(.chinaStandardTime).dateComponents([.month, .day], from: $0) } == DateComponents(month: 12, day: 21))
  }

  // MARK: - currentOrNextSpecialDay

  private var chinaSources: [SpecialDaySource] {
    [
      FestivalSource(converter: DayConverter(calendar: .chineseCalendarGTM8), timeZone: .chinaStandardTime),
      JieqiSource(timeZone: .chinaStandardTime),
    ]
  }

  @Test func currentOrNextReturnsTodayOnTheDay() {
    let result = date(2025, 1, 29).currentOrNextSpecialDay(sources: chinaSources, calendar: calendar(.chinaStandardTime))
    #expect(result?.day.name == "春節")
    #expect(result?.daysUntil == 0)
  }

  @Test func currentOrNextCountsCalendarDays() {
    // Late evening the day before: still one calendar day away, never zero.
    let eve = date(2025, 1, 28, hour: 23)
    let result = eve.currentOrNextSpecialDay(sources: chinaSources, calendar: calendar(.chinaStandardTime))
    #expect(result?.day.name == "春節")
    #expect(result?.daysUntil == 1)
  }

  @Test func currentOrNextPrefersFirstSource() {
    // 冬至 2025 is both a festival and a solar term; the festival is listed first.
    let result = date(2025, 12, 21).currentOrNextSpecialDay(sources: chinaSources, calendar: calendar(.chinaStandardTime))
    #expect(result?.day.kind == .festival)
    #expect(result?.daysUntil == 0)
  }

  @Test func nextSpecialDayNeverReportsZeroForTomorrow() {
    let eve = date(2025, 1, 28, hour: 23)
    #expect(eve.nextSpecialDay(sources: chinaSources)?.daysUntil ?? 0 >= 1)
  }

  // MARK: - upcomingSpecialDays

  @Test func upcomingCoversAYearSortedAndDeduplicated() {
    let start = date(2025, 1, 1)
    let events = start.upcomingSpecialDays(sources: chinaSources, within: 364, calendar: calendar(.chinaStandardTime))
    #expect(events.map(\.daysUntil) == events.map(\.daysUntil).sorted())
    #expect(events.allSatisfy { $0.daysUntil <= 364 })
    // 24 solar terms + 12 festivals, minus the duplicated 冬至 name.
    #expect(events.count == 35)
    #expect(events.filter { $0.day.name == "冬至" }.count == 1)
  }

  @Test func upcomingIncludesToday() {
    let events = date(2025, 1, 29).upcomingSpecialDays(sources: chinaSources, within: 0, calendar: calendar(.chinaStandardTime))
    #expect(events.map(\.day.name) == ["春節"])
  }

  // MARK: - RecurringDaySource

  @Test func lunarRecurringDayMatchesMidAutumn() {
    let day = RecurringDay(name: "團圓", reckoning: .lunar, month: 8, day: 15)
    let source = RecurringDaySource(days: [day], timeZone: .chinaStandardTime)
    let next = source.nextSpecialDay(after: date(2025, 9, 1))
    // Mid-Autumn 2025 is October 6.
    #expect(next.map { calendar(.chinaStandardTime).dateComponents([.year, .month, .day], from: $0.date) } == DateComponents(year: 2025, month: 10, day: 6))
    #expect(next?.kind == .custom)
    #expect(source.specialDays(on: date(2025, 10, 6)).map(\.name) == ["團圓"])
    #expect(source.specialDays(on: date(2025, 10, 7)).isEmpty)
  }

  @Test func lunarRecurringDayRollsIntoNextLunarYear() {
    // 臘月廿三 after it has passed in lunar year 乙巳 → the following one.
    let day = RecurringDay(name: "祭灶", reckoning: .lunar, month: 12, day: 23)
    let source = RecurringDaySource(days: [day], timeZone: .chinaStandardTime)
    let next = source.nextSpecialDay(after: date(2025, 1, 25))
    #expect(next.map { calendar(.chinaStandardTime).dateComponents([.year, .month, .day], from: $0.date) } == DateComponents(year: 2026, month: 2, day: 10))
  }

  @Test func gregorianLeapDayFallsBackToFebruary28() {
    let day = RecurringDay(name: "閏日", reckoning: .gregorian, month: 2, day: 29)
    let source = RecurringDaySource(days: [day], timeZone: .chinaStandardTime)
    #expect(source.specialDays(on: date(2025, 2, 28)).count == 1)
    #expect(source.specialDays(on: date(2028, 2, 29)).count == 1)
    #expect(source.specialDays(on: date(2028, 2, 28)).isEmpty)
  }

  @Test func lunarDayThirtyClampsInShortMonth() {
    let day = RecurringDay(name: "三十", reckoning: .lunar, month: 1, day: 30)
    let source = RecurringDaySource(days: [day], timeZone: .chinaStandardTime)
    guard let next = source.nextOccurrence(of: day, onOrAfter: date(2025, 1, 1)) else {
      Issue.record("no occurrence"); return
    }
    var lunar = Calendar(identifier: .chinese)
    lunar.timeZone = .chinaStandardTime
    let comps = lunar.dateComponents([.month, .day], from: next)
    let length = lunar.range(of: .day, in: .month, for: next)!.count
    #expect(comps.month == 1)
    #expect(comps.day == min(30, length))
  }

  @Test func nextRecurringDayIsStrictlyAfterToday() {
    let day = RecurringDay(name: "生日", reckoning: .gregorian, month: 5, day: 1)
    let source = RecurringDaySource(days: [day], timeZone: .chinaStandardTime)
    let next = source.nextSpecialDay(after: date(2025, 5, 1))
    #expect(next.map { calendar(.chinaStandardTime).component(.year, from: $0.date) } == 2026)
    let today = date(2025, 5, 1).currentOrNextSpecialDay(sources: [source], calendar: calendar(.chinaStandardTime))
    #expect(today?.daysUntil == 0)
  }

  @Test func invalidRecurringDaysAreIgnored() {
    let source = RecurringDaySource(days: [
      RecurringDay(name: "x", reckoning: .lunar, month: 13, day: 1),
      RecurringDay(name: "y", reckoning: .lunar, month: 1, day: 31),
    ])
    #expect(source.days.isEmpty)
  }

  @Test func recurringDayRoundTripsThroughJSON() throws {
    let day = RecurringDay(name: "媽媽生日", detail: "記得打電話", reckoning: .lunar, month: 8, day: 3)
    let decoded = try JSONDecoder().decode(RecurringDay.self, from: JSONEncoder().encode(day))
    #expect(decoded == day)
  }
}
