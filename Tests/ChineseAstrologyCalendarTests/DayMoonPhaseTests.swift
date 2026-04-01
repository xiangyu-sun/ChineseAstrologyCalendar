import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct DayMoonPhaseTests {

  @Test func moonPhaseMapping() {
    let mappings: [(Day, ChineseMoonPhase)] = [
      (.day1, .newMoon),
      (.day5, .waxingCrescent),
      (.day7, .firstQuarter),
      (.day14, .waxingGibbous),
      (.day15, .fullMoon),
      (.day18, .waningGibbous),
      (.day22, .lastQuarter),
      (.day24, .waningCrescent),
      (.day30, .darkMoon)
    ]
    for (day, phase) in mappings {
      #expect(day.moonPhase == phase, "Expected \(phase) for \(day)")
    }
  }
}
