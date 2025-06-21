import XCTest
@testable import ChineseAstrologyCalendar

final class DizhiAdditionalTests: XCTestCase {

  func testAliasAndOrgan() {
    XCTAssertEqual(Dizhi.zi.aliasName, "夜半")
    XCTAssertEqual(Dizhi.wu.organReference, "心")
  }

  func testNextAndPrevious() {
    XCTAssertEqual(Dizhi.hai.next, .zi)
    XCTAssertEqual(Dizhi.zi.previous, .hai)
  }

  func testHourInterval() {
    let interval = Dizhi.wu.hourInterval
    XCTAssertEqual(interval.start, 11)
    XCTAssertEqual(interval.end, 12)
  }

  func testFormattedMonthName() {
    XCTAssertEqual(Dizhi.yin.chineseCalendarMonthName, "寅月")
  }
}
