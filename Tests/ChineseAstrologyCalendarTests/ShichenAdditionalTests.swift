import XCTest
@testable import ChineseAstrologyCalendar

final class ShichenAdditionalTests: XCTestCase {

  func testNextStartDateAndCurrentKe() {
    var components = DateComponents()
    components.year = 2023
    components.month = 5
    components.day = 27
    components.hour = 9
    components.minute = 45
    let date = Calendar.current.date(from: components)!

    let shichen = Shichen(dizhi: .si, date: date)

    let start = Calendar.current.dateComponents([.hour, .minute], from: shichen.startDate)
    XCTAssertEqual(start.hour, 9)
    XCTAssertEqual(start.minute, 0)

    let next = Calendar.current.dateComponents([.hour, .minute], from: shichen.nextStartDate)
    XCTAssertEqual(next.hour, 11)
    XCTAssertEqual(next.minute, 0)

    XCTAssertEqual(shichen.currentKe, 3)
  }
}
