import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct EventModelTitleTests {

  @Test func titleFormatting() {
    var components = DateComponents()
    components.year = 2023
    components.month = 1
    components.day = 1
    let event = EventModel(date: Date(timeIntervalSinceReferenceDate: 0), name: .chuyi, dateComponents: components)

    #expect(event.title == "一 初一")
  }
}
