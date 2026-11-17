import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct DayBoundariesTests {

  private let shanghai = TimeZone(identifier: "Asia/Shanghai")!
  private let berlin = TimeZone(identifier: "Europe/Berlin")!
  private let losAngeles = TimeZone(identifier: "America/Los_Angeles")!
  private let santiago = TimeZone(identifier: "America/Santiago")!
  private let beirut = TimeZone(identifier: "Asia/Beirut")!

  private func calendar(_ timeZone: TimeZone) -> Calendar {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = timeZone
    return cal
  }

  private func date(_ year: Int, _ month: Int, _ day: Int, hour: Int = 0, minute: Int = 0, in timeZone: TimeZone) -> Date {
    calendar(timeZone).date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute))!
  }

  private func utc(_ iso: String) -> Date {
    ISO8601DateFormatter().date(from: iso)!
  }

  // 2025-03-01 18:30 UTC: Sunday 02:30 in Shanghai, 19:30 Saturday in Berlin, 10:30 Saturday in Los Angeles.
  private var instant: Date { utc("2025-03-01T18:30:00Z") }

  // MARK: - startOfDay(in:)

  @Test func startOfDayDependsOnTheZone() {
    #expect(instant.startOfDay(in: shanghai) == utc("2025-03-01T16:00:00Z"))
    #expect(instant.startOfDay(in: berlin) == utc("2025-02-28T23:00:00Z"))
    #expect(instant.startOfDay(in: losAngeles) == utc("2025-03-01T08:00:00Z"))
    #expect(instant.startOfDay(in: .chinaStandardTime) == instant.startOfDay(in: shanghai))
  }

  @Test func startOfDayOfMidnightIsItself() {
    let midnight = date(2025, 6, 1, in: berlin)
    #expect(midnight.startOfDay(in: berlin) == midnight)
  }

  // MARK: - nextMidnights(count:in:)

  @Test func nextMidnightsFromAFixedInstant() {
    #expect(instant.nextMidnights(count: 2, in: shanghai) == [utc("2025-03-02T16:00:00Z"), utc("2025-03-03T16:00:00Z")])
    #expect(instant.nextMidnights(count: 2, in: berlin) == [utc("2025-03-01T23:00:00Z"), utc("2025-03-02T23:00:00Z")])
    #expect(instant.nextMidnights(count: 2, in: losAngeles) == [utc("2025-03-02T08:00:00Z"), utc("2025-03-03T08:00:00Z")])
  }

  @Test func countZeroOrNegativeIsEmpty() {
    #expect(instant.nextMidnights(count: 0, in: shanghai).isEmpty)
    #expect(instant.nextMidnights(count: -3, in: shanghai).isEmpty)
  }

  @Test func startsStrictlyAfterAMidnight() {
    let midnight = date(2025, 6, 1, in: shanghai)
    #expect(midnight.nextMidnights(count: 1, in: shanghai) == [date(2025, 6, 2, in: shanghai)])
    let justBefore = midnight.addingTimeInterval(-1)
    #expect(justBefore.nextMidnights(count: 1, in: shanghai) == [midnight])
  }

  @Test(arguments: ["Asia/Shanghai", "Europe/Berlin", "America/Los_Angeles", "America/Santiago", "Asia/Beirut", "Australia/Lord_Howe"])
  func strictlyIncreasingAcrossAYear(identifier: String) {
    let tz = TimeZone(identifier: identifier)!
    let start = utc("2025-01-01T12:00:00Z")
    let midnights = start.nextMidnights(count: 400, in: tz)
    #expect(midnights.count == 400)
    #expect(midnights.first! > start)
    let cal = calendar(tz)
    var previousDay: DateComponents?
    for (a, b) in zip(midnights, midnights.dropFirst()) {
      #expect(a < b)
      // Consecutive values are consecutive calendar days, each at that day's start.
      #expect(cal.ordinality(of: .day, in: .era, for: b)! - cal.ordinality(of: .day, in: .era, for: a)! == 1)
    }
    for midnight in midnights {
      #expect(midnight.startOfDay(in: tz) == midnight)
      let day = cal.dateComponents([.year, .month, .day], from: midnight)
      #expect(day != previousDay)
      previousDay = day
    }
  }

  // MARK: - Daylight saving

  @Test func losAngelesSpringForwardAndFallBackDaysHaveOddLengths() {
    let before = date(2025, 3, 8, hour: 12, in: losAngeles)
    let spring = before.nextMidnights(count: 2, in: losAngeles)
    #expect(spring[1].timeIntervalSince(spring[0]) == 23 * 3600)

    let autumn = date(2025, 11, 1, hour: 12, in: losAngeles).nextMidnights(count: 2, in: losAngeles)
    #expect(autumn[1].timeIntervalSince(autumn[0]) == 25 * 3600)
  }

  @Test func berlinSpringForward() {
    let midnights = date(2025, 3, 29, hour: 12, in: berlin).nextMidnights(count: 2, in: berlin)
    #expect(midnights == [utc("2025-03-29T23:00:00Z"), utc("2025-03-30T22:00:00Z")])
  }

  /// Santiago skips 2025-09-07 00:00 (clocks jump to 01:00), so that day starts at 01:00 local.
  @Test func santiagoSkippedMidnightBecomesFirstInstantOfDay() {
    let evening = date(2025, 9, 6, hour: 20, in: santiago)
    let midnights = evening.nextMidnights(count: 2, in: santiago)
    let cal = calendar(santiago)
    #expect(cal.component(.day, from: midnights[0]) == 7)
    #expect(cal.component(.hour, from: midnights[0]) == 1)
    #expect(midnights[0] == utc("2025-09-07T04:00:00Z"))
    #expect(midnights[1] == utc("2025-09-08T03:00:00Z"))
    #expect(evening.startOfDay(in: santiago) == utc("2025-09-06T04:00:00Z"))
  }

  /// Santiago repeats 23:00 on 2025-04-05 (24:00 becomes 23:00), so 5 April is 25 hours long.
  @Test func santiagoFallBack() {
    let midnights = date(2025, 4, 4, hour: 12, in: santiago).nextMidnights(count: 2, in: santiago)
    #expect(midnights == [utc("2025-04-05T03:00:00Z"), utc("2025-04-06T04:00:00Z")])
  }

  /// Beirut skips 2025-03-30 00:00 (clocks jump to 01:00).
  @Test func beirutSkippedMidnight() {
    let evening = date(2025, 3, 29, hour: 22, in: beirut)
    let midnights = evening.nextMidnights(count: 2, in: beirut)
    let cal = calendar(beirut)
    #expect(cal.component(.day, from: midnights[0]) == 30)
    #expect(cal.component(.hour, from: midnights[0]) == 1)
    #expect(midnights[0] == utc("2025-03-29T22:00:00Z"))
    #expect(midnights[1] == utc("2025-03-30T21:00:00Z"))
  }

  /// A value inside the skipped-midnight day still finds the next day's start, not the same one.
  @Test func fromInsideASkippedMidnightDay() {
    let firstInstant = utc("2025-09-07T04:00:00Z")
    #expect(firstInstant.startOfDay(in: santiago) == firstInstant)
    #expect(firstInstant.nextMidnights(count: 1, in: santiago) == [utc("2025-09-08T03:00:00Z")])
  }
}
