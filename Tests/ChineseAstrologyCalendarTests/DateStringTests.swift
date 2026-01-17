import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct DateStringTests {

  var event: EventModel {
    let component = DateComponents(calendar: .current, year: 2023, month: 6, day: 7, hour: 17)

    let date = Calendar.current.date(from: component)

    return DayConverter(calendar: .chineseCalendarGTM8).find(day: .chuyi, month: .yin, inNextYears: 1, from: date!).first!
  }

  @Test func chineseYearMonthDate() throws {
    let component = DateComponents(calendar: .current, year: 2022, month: 6, day: 7, hour: 17)

    let date = Calendar.current.date(from: component)

    #expect(date?.chineseYearMonthDate == "壬寅年五月初九")
  }

  @Test func chineseYearMonthDateZodiac() throws {
    let component = DateComponents(calendar: .current, year: 2022, month: 6, day: 7, hour: 17)

    let date = Calendar.current.date(from: component)

    #expect(date?.displayStringOfChineseYearMonthDateWithZodiac == "壬寅虎年五月初九")
  }

  @Test func chineseYearMonthDateZodiacGTM8() throws {
    let component = DateComponents(calendar: .current, year: 2023, month: 1, day: 22, hour: 0)

    let date = Calendar.current.date(from: component)

    #expect(date?.displayStringOfChineseYearMonthDateWithZodiacGTM8 == "癸卯兔年正月初一")
  }

  @Test func chineseYearMonthDateZodiacCurrentCalendar() throws {
    let component = DateComponents(calendar: .current, year: 2023, month: 1, day: 22, hour: 0)

    let date = Calendar.current.date(from: component)

    #expect(date?.displayStringOfChineseYearMonthDateWithZodiac == "癸卯兔年正月初一")
  }

  @Test func chineseYearMonthDateZodiacGTM8WithEventModel() throws {
    let date = Date(timeIntervalSinceReferenceDate: 696009600)

    #expect(event.date.displayStringOfChineseYearMonthDateWithZodiacGTM8 == "甲辰龙年正月初一")
  }

  @Test func chineseMonth() throws {
    let dizhi = Dizhi.you

    let component2 = DateComponents(calendar: .current, year: 2022, month: 8, day: 10, hour: 17)

    let date2 = Calendar.current.date(from: component2)

    #expect(dizhi.formattedMonth == Dizhi.monthFormatter.string(from: date2!))
  }

  @Test func chineseMonthAndDate() throws {
    let component = DateComponents(calendar: .current, year: 2022, month: 11, day: 1, hour: 17)

    let date = Calendar.current.date(from: component)
    #expect(date!.chineseYearMonthDate == "壬寅年十月初八")
  }

  @Test func chineseMonthAndDateGTM8() throws {
    let component = DateComponents(calendar: .current, year: 2022, month: 11, day: 1, hour: 17)

    let date = Calendar.current.date(from: component)
    #expect(date!.chineseYearMonthDateGTM8 == "壬寅年十月初九")
  }

}
