import Foundation
//
//  JieqiTests.swift
//
//
//  Created by Xiangyu Sun on 24/12/22.
//

import Astral
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct JieqiTests {

  @Test func celestialLongitudes() throws {
    #expect(
      Jieqi.allCases.map(\.celestialLongitude) ==
      [0, 15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180, 195, 210, 225, 240, 255, 270, 285, 300, 315, 330, 345])
  }

  @Test func monthFromCelestialLongitudeMapping() {
    // Expected mapping for rawValue 0–23
    let expectedMonths = [3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 1, 1, 2, 2, 3]
    for jie in Jieqi.allCases {
      let expected = expectedMonths[jie.rawValue]
      #expect(jie.monthFromCelestialLongitude == expected,
             "Expected month \(expected) for \(jie.stringValue) (rawValue=\(jie.rawValue)), got \(jie.monthFromCelestialLongitude)")
    }
  }

  // MARK: - Date.jieqi

  /// Regression test for the near-equinox period bug.
  /// `currentSolarTerm()` returns (normalizedLong + 7.5) / 15.  Applying floor()
  /// directly gave the *nearest* solar term, not the *current period* — and could
  /// overflow to 24 (nil).  Subtracting 0.5 before flooring yields
  /// floor(normalizedLong / 15): the solar term period that most recently started.
  @Test func dateJieqiNearSpringEquinox() {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(identifier: "UTC")!
    // March 16, 2026: sun ~356°, still inside awakeningOfInsects (started ~March 6 at 345°).
    let beforeEquinox = cal.date(from: DateComponents(year: 2026, month: 3, day: 16))!
    #expect(beforeEquinox.jieqi == .awakeningOfInsects)
    // March 21, 2026: sun ~1°, inside springEquinox (Spring Equinox passed ~March 20 at 0°).
    let afterEquinox = cal.date(from: DateComponents(year: 2026, month: 3, day: 21))!
    #expect(afterEquinox.jieqi == .springEquinox)
  }

  /// Verifies Date.jieqi never returns nil for a sample of dates throughout the year.
  @Test func dateJieqiNeverNil() {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(identifier: "UTC")!
    for month in 1...12 {
      for day in [1, 10, 20] {
        let date = cal.date(from: DateComponents(year: 2025, month: month, day: day))!
        #expect(date.jieqi != nil, "Expected non-nil jieqi for 2025-\(month)-\(day)")
      }
    }
  }

  // MARK: - Jieqi.jieqiPairs

  /// Verifies all 12 jie-qi pairs are present and that the last pair wraps correctly.
  /// Bug: Jieqi(rawValue: 24) overflowed to nil before the % 24 fix.
  @Test func jieqiPairsCompleteness() {
    let pairs = Jieqi.springEquinox.jieqiPairs
    #expect(pairs.count == 12)
    // The last pair is (awakeningOfInsects, springEquinox) — qi wraps around from rawValue 24 to 0.
    #expect(pairs.last?.jie == .awakeningOfInsects)
    #expect(pairs.last?.qi == .springEquinox)
  }

  @Test func jieqiPairsNoDuplicatesOrNilFallbacks() {
    let pairs = Jieqi.springEquinox.jieqiPairs
    let allJie = pairs.map(\.jie)
    let allQi = pairs.map(\.qi)
    // All 24 solar terms must appear exactly once across the 12 pairs.
    #expect(Set(allJie).count == 12)
    #expect(Set(allQi).count == 12)
    #expect(Set(allJie).isDisjoint(with: Set(allQi)))
  }

  // MARK: - Jieqi.dizhi

  /// Every Jieqi must map to a non-nil Dizhi.
  /// Bug: rawValues 19 (minorCold) and 20 (majorCold) produced Dizhi(rawValue: 0) = nil.
  @Test func jieqiDizhiNeverNil() {
    for jieqi in Jieqi.allCases {
      #expect(jieqi.dizhi != nil, "\(jieqi.stringValue) (rawValue \(jieqi.rawValue)) has nil dizhi")
    }
  }

  // MARK: - Jieqi.next

  @Test func jieqiNext() {
    #expect(Jieqi.awakeningOfInsects.next == .springEquinox)
    #expect(Jieqi.springEquinox.next == .clearAndBright)
    #expect(Jieqi.winterSolstice.next == .minorCold)
  }

  /// `preciseNextSolarTermDate()` returns a date at the exact boundary.
  /// Due to Newton iteration tolerance (±1e-4), the date can land
  /// slightly before the crossing, causing `floor(result - 0.5)` to
  /// evaluate to -1 at the springEquinox boundary. The modulo fix must handle this.
  @Test func dateJieqiAtBoundaryDate() {
    let boundaryDate = preciseNextSolarTermDate(iterations: 10)
    // The jieqi at a boundary date must never be nil.
    #expect(boundaryDate.jieqi != nil)
  }

  /// Each consecutive pair of Jieqi (one jie + one qi) belongs to the same Dizhi month.
  /// Expected mapping derived from QijieDizhiTests (Dizhi.jie / Dizhi.qi truth).
  @Test func jieqiDizhiMapping() {
    let expected: [(Jieqi, Dizhi)] = [
      (.springEquinox, .yin), (.clearAndBright, .yin),
      (.grainRain, .mao), (.startOfSummer, .mao),
      (.grainBuds, .chen), (.grainInEar, .chen),
      (.summerSolstice, .si), (.minorHeat, .si),
      (.majorHeat, .wu), (.startOfAutumn, .wu),
      (.endOfHeat, .wei), (.whiteDew, .wei),
      (.autumnEquinox, .shen), (.coldDew, .shen),
      (.frostDescent, .you), (.startOfWinter, .you),
      (.minorSnow, .xu), (.majorSnow, .xu),
      (.winterSolstice, .hai), (.minorCold, .hai),
      (.majorCold, .zi), (.startOfSpring, .zi),
      (.rainWater, .chou), (.awakeningOfInsects, .chou),
    ]
    for (jieqi, expectedDizhi) in expected {
      #expect(jieqi.dizhi == expectedDizhi,
              "\(jieqi.stringValue) should map to \(expectedDizhi.chineseCharacter)")
    }
  }

}
