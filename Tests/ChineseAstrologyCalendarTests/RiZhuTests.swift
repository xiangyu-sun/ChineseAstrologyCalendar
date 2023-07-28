import XCTest
@testable import ChineseAstrologyCalendar

final class RiZhuTests: XCTestCase {

  func test_chineseYearMonthDateZodia() throws {
    let component = DateComponents(calendar: .current, year: 2010, month: 4, day: 12)

    XCTAssertEqual(component.riZhu?.description, "壬辰")
  }

  func test_rizhu() throws {
    let component = DateComponents(calendar: .current, year: 2023, month: 1, day: 23)

    XCTAssertEqual(component.riZhu?.description, "辛巳")
    XCTAssertEqual(component.yue?.description, "丙寅")
  }

}
