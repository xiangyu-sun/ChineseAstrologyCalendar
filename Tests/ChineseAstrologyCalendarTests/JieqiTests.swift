import Foundation
//
//  JieqiTests.swift
//
//
//  Created by Xiangyu Sun on 24/12/22.
//

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

  /// Regression test for the rawValue overflow bug.
  /// When the sun is within 7.5° of the Spring Equinox (lon ~352.5°–360°),
  /// `currentSolarTerm` returns a value in [24, 24.5), which must wrap to 0 (chunfen).
  /// This window falls approximately March 12–20 each year.
  @Test func dateJieqiNearSpringEquinox() {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(identifier: "UTC")!
    // March 16, 2026 is ~4 days before the Spring Equinox (~March 20).
    // The formula rounds to chunfen at this longitude.
    let date = cal.date(from: DateComponents(year: 2026, month: 3, day: 16))!
    #expect(date.jieqi != nil)
    #expect(date.jieqi == .chunfen)
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
    let pairs = Jieqi.chunfen.jieqiPairs
    #expect(pairs.count == 12)
    // The last pair is (jingzhe, chunfen) — qi wraps around from rawValue 24 to 0.
    #expect(pairs.last?.jie == .jingzhe)
    #expect(pairs.last?.qi == .chunfen)
  }

  @Test func jieqiPairsNoDuplicatesOrNilFallbacks() {
    let pairs = Jieqi.chunfen.jieqiPairs
    let allJie = pairs.map(\.jie)
    let allQi = pairs.map(\.qi)
    // All 24 solar terms must appear exactly once across the 12 pairs.
    #expect(Set(allJie).count == 12)
    #expect(Set(allQi).count == 12)
    #expect(Set(allJie).isDisjoint(with: Set(allQi)))
  }

  // MARK: - Jieqi.dizhi

  /// Every Jieqi must map to a non-nil Dizhi.
  /// Bug: rawValues 19 (xiaohan) and 20 (dahan) produced Dizhi(rawValue: 0) = nil.
  @Test func jieqiDizhiNeverNil() {
    for jieqi in Jieqi.allCases {
      #expect(jieqi.dizhi != nil, "\(jieqi.stringValue) (rawValue \(jieqi.rawValue)) has nil dizhi")
    }
  }

  /// Each consecutive pair of Jieqi (one jie + one qi) belongs to the same Dizhi month.
  /// Expected mapping derived from QijieDizhiTests (Dizhi.jie / Dizhi.qi truth).
  @Test func jieqiDizhiMapping() {
    let expected: [(Jieqi, Dizhi)] = [
      (.chunfen, .yin), (.qingming, .yin),
      (.guyu, .mao), (.lixia, .mao),
      (.xiaoman, .chen), (.mangzhong, .chen),
      (.xiazhi, .si), (.xiaoshu, .si),
      (.dashu, .wu), (.liqiu, .wu),
      (.chushu, .wei), (.bailu, .wei),
      (.qiufen, .shen), (.hanlu, .shen),
      (.shuangjiang, .you), (.lidong, .you),
      (.xiaoxue, .xu), (.daxue, .xu),
      (.dongzhi, .hai), (.xiaohan, .hai),
      (.dahan, .zi), (.lichun, .zi),
      (.yushui, .chou), (.jingzhe, .chou),
    ]
    for (jieqi, expectedDizhi) in expected {
      #expect(jieqi.dizhi == expectedDizhi,
              "\(jieqi.stringValue) should map to \(expectedDizhi.chineseCharacter)")
    }
  }

}
