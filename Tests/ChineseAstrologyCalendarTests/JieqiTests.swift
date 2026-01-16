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

}
