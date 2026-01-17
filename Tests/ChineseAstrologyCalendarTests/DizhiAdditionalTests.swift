import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct DizhiAdditionalTests {

  @Test func aliasAndOrgan() {
    #expect(Dizhi.zi.aliasName == "夜半")
    #expect(Dizhi.wu.organReference == "心")
  }

  @Test func nextAndPrevious() {
    #expect(Dizhi.hai.next == .zi)
    #expect(Dizhi.zi.previous == .hai)
  }

  @Test func hourInterval() {
    let interval = Dizhi.wu.hourInterval
    #expect(interval.start == 11)
    #expect(interval.end == 12)
  }

  @Test func formattedMonthName() {
    #expect(Dizhi.yin.chineseCalendarMonthName == "寅月")
  }
}
