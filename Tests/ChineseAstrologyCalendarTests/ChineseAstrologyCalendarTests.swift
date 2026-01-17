import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct ChineseAstrologyCalendarTests {

  @Test func nianGanIsNotNil() {
    #expect(Date().dateComponentsFromChineseCalendar().nianGan != nil)
  }

  @Test func nianGanListHasTenElements() {
    for i in 1...10 {
      #expect(Tiangan(rawValue: i) != nil)
    }
  }

  @Test func nianZhiIsNotNil() {
    #expect(Date().dateComponentsFromChineseCalendar().nianZhi != nil)
  }

  @Test func nianZhiListHasTwelveElements() {
    for i in 1...12 {
      #expect(Dizhi(rawValue: i) != nil)
    }
  }

  @Test func yueZhiIsNotNil() {
    #expect(Date().dateComponentsFromChineseCalendar().yueZhi != nil)
  }

  @Test func yueGanIsNotNil() {
    #expect(Date().dateComponentsFromChineseCalendar().yueGan != nil)
  }
}
