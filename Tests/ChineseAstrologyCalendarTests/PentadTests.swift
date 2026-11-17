import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct PentadTests {

  @Test(arguments: Jieqi.allCases)
  func everyTermHasThreePentads(_ jieqi: Jieqi) {
    let pentads = jieqi.pentads
    #expect(pentads.count == 3)
    for text in pentads {
      #expect(!text.isEmpty)
      #expect(!text.contains("又五日"))
      #expect(!text.contains("之日"))
      #expect(!text.hasPrefix("，") && !text.hasSuffix("，") && !text.hasSuffix("。"))
    }
  }

  @Test func knownPentadTexts() {
    #expect(Jieqi.startOfSpring.pentads == ["東風解凍", "蟄蟲始振", "魚上冰（魚陟負冰)"])
    #expect(Pentad(jieqi: .startOfSpring, index: 0).text == "東風解凍")
  }

  @Test func seventyTwoDistinctPentads() {
    let all = (0..<72).map { Pentad(longitude: Double($0) * 5 + 2.5) }
    #expect(Set(all).count == 72)
    #expect(all.map(\.ordinal) == Array(0..<72))
    #expect(Pentad(longitude: 0) == Pentad(jieqi: .springEquinox, index: 0))
    #expect(Pentad(longitude: 359.9) == Pentad(jieqi: .awakeningOfInsects, index: 2))
    #expect(Pentad(longitude: -0.1) == Pentad(longitude: 359.9))
    #expect(Pentad(jieqi: .awakeningOfInsects, index: 2).next == Pentad(jieqi: .springEquinox, index: 0))
    #expect(Pentad(jieqi: .springEquinox, index: 0).previous == Pentad(jieqi: .awakeningOfInsects, index: 2))
  }

  @Test(arguments: [1990, 2025, 2026, 2050])
  func yearBoundariesContainTheTransits(_ year: Int) {
    let boundaries = PentadBoundary.boundaries(inYear: year)
    // ~5.07 days apart, so 71 or 72 fit in a calendar year.
    #expect((71...72).contains(boundaries.count))
    #expect(boundaries == boundaries.sorted())
    // Consecutive pentads, wrapping at 春分.
    for (a, b) in zip(boundaries, boundaries.dropFirst()) {
      #expect(a.pentad.next == b.pentad)
      let days = b.instant.timeIntervalSince(a.instant) / 86_400
      #expect(days > 4.5 && days < 5.6)
    }
    let transits = JieqiTransit.transits(inYear: year)
    let firsts = boundaries.filter { $0.pentad.index == 0 }
    #expect(firsts.count == 24)
    for (boundary, transit) in zip(firsts, transits) {
      #expect(boundary.pentad.jieqi == transit.jieqi)
      #expect(abs(boundary.instant.timeIntervalSince(transit.instant)) <= 2)
    }
  }

  @Test func oneTropicalYearHasSeventyTwoBoundaries() {
    let transit = Jieqi.winterSolstice.transit(inYear: 2025)!
    let next = Jieqi.winterSolstice.transit(after: transit)
    let boundaries = PentadBoundary.boundaries(from: transit, to: next)
    #expect(boundaries.count == 72)
    #expect(boundaries.first?.pentad == Pentad(jieqi: .winterSolstice, index: 0))
    #expect(boundaries.last?.pentad == Pentad(jieqi: .majorSnow, index: 2))
  }

  @Test func boundaryLongitudesAreMultiplesOfFive() {
    for boundary in PentadBoundary.boundaries(inYear: 2026) {
      let before = boundary.instant.addingTimeInterval(-60).solarLongitude
      let after = boundary.instant.addingTimeInterval(60).solarLongitude
      #expect(Pentad(longitude: before) == boundary.pentad.previous)
      #expect(Pentad(longitude: after) == boundary.pentad)
    }
  }

  @Test func dateIndexAndBoundariesAgree() {
    let boundaries = PentadBoundary.boundaries(inYear: 2025)
    for (a, b) in zip(boundaries, boundaries.dropFirst()) {
      let middle = a.instant.addingTimeInterval(b.instant.timeIntervalSince(a.instant) / 2)
      #expect(middle.pentad == a.pentad)
      #expect(middle.pentadIndex == a.pentad.index)
      #expect(abs(middle.currentPentadBoundary.instant.timeIntervalSince(a.instant)) <= 2)
      #expect(middle.nextPentadBoundary.pentad == b.pentad)
      #expect(abs(middle.nextPentadBoundary.instant.timeIntervalSince(b.instant)) <= 2)
    }
  }

  @Test func rangeIncludesBoundaryAtStartAndExcludesEnd() {
    let year = PentadBoundary.boundaries(inYear: 2026)
    let start = year[10].instant
    let end = year[13].instant
    let range = PentadBoundary.boundaries(from: start, to: end)
    #expect(range.map(\.pentad) == year[10..<13].map(\.pentad))
    #expect(PentadBoundary.boundaries(from: end, to: start).isEmpty)
  }

  @Test func pentadStartAfterAndBefore() {
    let date = JieqiTransitTests.hkt("2026-02-10 12:00")
    #expect(date.pentad == Pentad(jieqi: .startOfSpring, index: 1))
    let second = date.pentad
    let start = second.start(before: date)
    #expect(second.start(after: start) > start.addingTimeInterval(360 * 86_400))
    let following = second.start(after: date)
    #expect(following.timeIntervalSince(start) > 360 * 86_400)
    #expect(abs(second.start(before: following).timeIntervalSince(start)) <= 2)
  }
}
