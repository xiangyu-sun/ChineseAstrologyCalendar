import XCTest
@testable import ChineseAstrologyCalendar

final class DayMoonPhaseTests: XCTestCase {

  func testMoonPhaseMapping() {
    let mappings: [(Day, ChineseMoonPhase)] = [
      (.chuyi, .朔),
      (.chuwu, .蛾眉月),
      (.chuqi, .上弦月),
      (.shisi, .漸盈凸月),
      (.shiwu, .望),
      (.shiba, .漸虧凸月),
      (.erer, .下弦月),
      (.ersi, .殘月),
      (.sanshi, .晦)
    ]
    for (day, phase) in mappings {
      XCTAssertEqual(day.moonPhase, phase, "Expected \(phase) for \(day)")
    }
  }
}
