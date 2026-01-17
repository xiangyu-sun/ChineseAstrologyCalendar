import Foundation

//  Created by 孙翔宇 on 03/07/2020.
//

import Testing
@testable import ChineseAstrologyCalendar

@Suite struct IntegrationTests {

  @Test func nianGanIsYi() {
    let date = setupDateOne()
    #expect(date.dateComponentsFromCurrentCalendar.nianGan == Tiangan.yi)
  }

  @Test func nianGan() {
    let calendar = Calendar(identifier: .gregorian)
    let timeZone = TimeZone.chinaStandardTime
    let comp = DateComponents(calendar: calendar, timeZone: timeZone, year: 2021, month: 1, day: 10)
    let date = calendar.date(from: comp)!
    #expect(date.dateComponentsFromChineseCalendar().nianZhi == Dizhi.zi)
    #expect(date.dateComponentsFromChineseCalendar().nianGan == Tiangan.geng)
    #expect(date.dateComponentsFromChineseCalendar().yueZhi == Dizhi.zi)
  }

  @Test func nianGan2023() {
    let calendar = Calendar(identifier: .gregorian)
    let timeZone = TimeZone.chinaStandardTime
    let comp = DateComponents(calendar: calendar, timeZone: timeZone, year: 2023, month: 1, day: 23)
    let date = calendar.date(from: comp)!
    #expect(date.dateComponentsFromChineseCalendar().nianZhi == Dizhi.mao)
    #expect(date.dateComponentsFromChineseCalendar().nianGan == Tiangan.kui)
    #expect(date.dateComponentsFromChineseCalendar().yueZhi == Dizhi.yin)
  }

  @Test func nianZhiIsWei() {
    let date = setupDateOne()
    #expect(date.dateComponentsFromCurrentCalendar.nianZhi == Dizhi.wei)
  }

  @Test func yueZhiIsShen() {
    let date = setupDateOne()
    #expect(date.dateComponentsFromChineseCalendar().yueZhi == Dizhi.wu)
  }

  @Test(.enabled(if: false)) func yueGanIsJia() {
    // XCTExpectFailure: This test is expected to fail
    let date = setupDateOne()
    #expect(date.dateComponentsFromChineseCalendar().yueGan == Tiangan.kui)
  }

  @Test func yueZhiIsHai() {
    let date = setupDateTwo()
    #expect(date.dateComponentsFromChineseCalendar().yueZhi == Dizhi.you)
  }

  @Test func yueGanIsJi() {
    let date = setupDateTwo()
    #expect(date.dateComponentsFromChineseCalendar().yueGan == Tiangan.ji)
  }

  @Test func nianGanIsRen() {
    let date = setupDateThree()
    #expect(date.dateComponentsFromCurrentCalendar.nianGan == Tiangan.ren)
  }

  @Test func nianZhiIsZi() {
    let date = setupDateThree()
    #expect(date.dateComponentsFromCurrentCalendar.nianZhi == Dizhi.zi)
  }

  func setupDateOne() -> Date {
    let calendar = Calendar(identifier: .gregorian)
    let timeZone = TimeZone.chinaStandardTime
    let comp = DateComponents(calendar: calendar, timeZone: timeZone, year: 2015, month: 7, day: 3)
    return calendar.date(from: comp)!
  }

  func setupDateTwo() -> Date {
    let calendar = Calendar(identifier: .gregorian)
    let timeZone = TimeZone.chinaStandardTime
    let comp = DateComponents(calendar: calendar, timeZone: timeZone, year: 2012, month: 10, day: 3)
    return calendar.date(from: comp)!
  }

  func setupDateThree() -> Date {
    let calendar = Calendar(identifier: .gregorian)
    let timeZone = TimeZone.chinaStandardTime
    let comp = DateComponents(calendar: calendar, timeZone: timeZone, year: 1912, month: 2, day: 18)
    return calendar.date(from: comp)!
  }

}
