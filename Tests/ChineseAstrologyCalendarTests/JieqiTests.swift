//
//  JieqiTests.swift
//
//
//  Created by Xiangyu Sun on 24/12/22.
//

import XCTest
@testable import ChineseAstrologyCalendar

final class JieqiTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() throws {
    XCTAssertEqual(
      Jieqi.allCases.map(\.celestialLongitude),
      [315, 330, 345, 0, 15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180, 195, 210, 225, 240, 255, 270, 285, 300])
  }
  
  func testMonthFromCelestialLongitudeMapping() {
    // Expected mapping for rawValue 0–23
    let expectedMonths = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12]
    for jie in Jieqi.allCases {
      let expected = expectedMonths[jie.rawValue]
      XCTAssertEqual(jie.monthFromCelestialLongitude, expected,
                     "Expected month \(expected) for \(jie.stringValue) (rawValue=\(jie.rawValue)), got \(jie.monthFromCelestialLongitude)")
    }
  }
  
  
}
