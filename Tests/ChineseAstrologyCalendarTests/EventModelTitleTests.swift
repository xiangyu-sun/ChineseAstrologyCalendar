import XCTest
@testable import ChineseAstrologyCalendar

final class EventModelTitleTests: XCTestCase {

  func testTitleFormatting() {
    var components = DateComponents()
    components.year = 2023
    components.month = 1
    components.day = 1
    let event = EventModel(date: Date(timeIntervalSinceReferenceDate: 0), name: .chuyi, dateComponents: components)

    XCTAssertEqual(event.title, "Optional(\"一\") 初一")
  }
}
