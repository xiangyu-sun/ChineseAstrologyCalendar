import Foundation
import Testing

@testable import ChineseAstrologyCalendar

@Suite struct ChineseNewYearTests {
  let calendar = Calendar.current
  let converter = DayConverter()

  let formatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "en_US")
    f.dateStyle = .short
    f.timeStyle = .none
    return f
  }()

  // MARK: - nextChineseNewYear

  @Test func nextChineseNewYearFromNovember2022() throws {
    // CNY 2023 is January 22, 2023
    let from = try #require(calendar.date(from: DateComponents(calendar: calendar, year: 2022, month: 11, day: 1)))
    let cny = try #require(converter.nextChineseNewYear(from: from))
    #expect(formatter.string(from: cny) == "1/22/23")
  }

  @Test func nextChineseNewYearFromOctober2023() throws {
    // CNY 2024 is February 10, 2024
    let from = try #require(calendar.date(from: DateComponents(calendar: calendar, year: 2023, month: 10, day: 1)))
    let cny = try #require(converter.nextChineseNewYear(from: from))
    #expect(formatter.string(from: cny) == "2/10/24")
  }

  @Test func nextChineseNewYearFromOctober2024() throws {
    // CNY 2025 is January 29, 2025
    let from = try #require(calendar.date(from: DateComponents(calendar: calendar, year: 2024, month: 10, day: 1)))
    let cny = try #require(converter.nextChineseNewYear(from: from))
    #expect(formatter.string(from: cny) == "1/29/25")
  }

  @Test func nextChineseNewYearFromOctober2025() throws {
    // CNY 2026 is February 17, 2026
    let from = try #require(calendar.date(from: DateComponents(calendar: calendar, year: 2025, month: 10, day: 1)))
    let cny = try #require(converter.nextChineseNewYear(from: from))
    #expect(formatter.string(from: cny) == "2/17/26")
  }

  @Test func nextChineseNewYearOnNewYearDayItself() throws {
    // When queried on CNY itself, should return that same day
    let cnyDay = try #require(calendar.date(from: DateComponents(calendar: calendar, year: 2024, month: 2, day: 10)))
    let cny = try #require(converter.nextChineseNewYear(from: cnyDay))
    #expect(formatter.string(from: cny) == "2/10/24")
  }

  // MARK: - isWithinMonths(beforeChineseNewYear)

  @Test func isWithinThreeMonthsBeforeCNY_trueJustBeforeWindow() throws {
    // CNY 2026 = Feb 17, 2026 → 3 months before = Nov 17, 2025
    // Nov 18, 2025 should be inside the window
    let date = try #require(calendar.date(from: DateComponents(calendar: calendar, year: 2025, month: 11, day: 18)))
    #expect(converter.isWithinMonths(3, beforeChineseNewYearFrom: date))
  }

  @Test func isWithinThreeMonthsBeforeCNY_trueOnWindowStart() throws {
    // CNY 2026 = Feb 17, 2026 → 3 months before = Nov 17, 2025
    let date = try #require(calendar.date(from: DateComponents(calendar: calendar, year: 2025, month: 11, day: 17)))
    #expect(converter.isWithinMonths(3, beforeChineseNewYearFrom: date))
  }

  @Test func isWithinThreeMonthsBeforeCNY_falseJustBeforeWindowStart() throws {
    // CNY 2026 = Feb 17, 2026 → 3 months before = Nov 17, 2025
    // Nov 16, 2025 is outside the window
    let date = try #require(calendar.date(from: DateComponents(calendar: calendar, year: 2025, month: 11, day: 16)))
    #expect(!converter.isWithinMonths(3, beforeChineseNewYearFrom: date))
  }

  @Test func isWithinThreeMonthsBeforeCNY_falseSummerFar() throws {
    // July 2025 is far from CNY 2026 (Feb 17)
    let date = try #require(calendar.date(from: DateComponents(calendar: calendar, year: 2025, month: 7, day: 1)))
    #expect(!converter.isWithinMonths(3, beforeChineseNewYearFrom: date))
  }

  @Test func isWithinThreeMonthsBeforeCNY_falseOnNewYearDay() throws {
    // On CNY itself the date is no longer "before" CNY
    let date = try #require(calendar.date(from: DateComponents(calendar: calendar, year: 2026, month: 2, day: 17)))
    #expect(!converter.isWithinMonths(3, beforeChineseNewYearFrom: date))
  }

  @Test func isWithinOneMonthBeforeCNY_true() throws {
    // CNY 2025 = Jan 29, 2025 → 1 month before = Dec 29, 2024
    let date = try #require(calendar.date(from: DateComponents(calendar: calendar, year: 2025, month: 1, day: 15)))
    #expect(converter.isWithinMonths(1, beforeChineseNewYearFrom: date))
  }

  @Test func isWithinOneMonthBeforeCNY_falseEarlierInDecember() throws {
    // CNY 2025 = Jan 29, 2025 → 1 month before = Dec 29, 2024
    // Dec 28, 2024 is just outside the 1-month window
    let date = try #require(calendar.date(from: DateComponents(calendar: calendar, year: 2024, month: 12, day: 28)))
    #expect(!converter.isWithinMonths(1, beforeChineseNewYearFrom: date))
  }
}
