import XCTest
@testable import ChineseAstrologyCalendar

final class ShiZhuTests: XCTestCase {

  func test_shizhu() throws {
    let component = DateComponents(calendar: .current, year: 2010, month: 4, day: 12, hour: 3)

    XCTAssertEqual(component.shiZhu?.description, "甲寅")
  }
}
