import XCTest
@testable import ChineseAstrologyCalendar

final class ChineseAstrologyCalendarTests: XCTestCase {

  static var allTests = [
    ("testNianGanToNotbeNil", testNianGanToNotbeNil),
  ]

  func testNianGanToNotbeNil() {
    XCTAssertNotNil(Date().dateComponentsFromChineseCalendar.nianGan)
  }

  func testNianGanListHasTenElements() {
    for i in 1...10 {
      XCTAssertNotNil(Tiangan(rawValue: i))
    }
  }

  func testNianZhiToNotbeNil() {
    XCTAssertNotNil(Date().dateComponentsFromChineseCalendar.nianZhi)
  }

  func testNianZhiListHasTwelveElements() {
    for i in 1...12 {
      XCTAssertNotNil(Dizhi(rawValue: i))
    }
  }

  func testYuezhiToNotBeNil() {
    XCTAssertNotNil(Date().dateComponentsFromChineseCalendar.yueZhi)
  }

  func testYueGanToNotBeNil() {
    XCTAssertNotNil(Date().dateComponentsFromChineseCalendar.yueZhi)
  }
}
