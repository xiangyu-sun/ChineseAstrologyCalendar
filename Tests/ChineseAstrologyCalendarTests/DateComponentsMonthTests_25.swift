//
//  DateComponentsMonthTests 2.swift
//  ChineseAstrologyCalendar
//
//  Created by Xiangyu Sun on 9/6/25.
//


import XCTest
@testable import ChineseAstrologyCalendar

final class DateComponentsMonthTests_25: XCTestCase {
  
  func testYueZhiAndYueGan_OnFixedJune2025Dates() {
    let calendar = Calendar(identifier: .gregorian)
    
    // Test data: (year, month, day, expectedGan, expectedZhi)
    let testCases: [(Int, Int, Int, Tiangan, Dizhi)] = [
      (2025, 6,  9,  .ren, .wu),
      (2025, 6, 10,  .ren, .wu),
      (2025, 6, 11,  .ren, .wu),
      (2025, 6, 12,  .ren, .wu),
      (2025, 6, 13,  .ren, .wu),
    ]
    
    for (year, month, day, expectedGan, expectedZhi) in testCases {
      // Build a Date from the components
      var dc = DateComponents()
      dc.year = year
      dc.month = month
      dc.day = day
      
      
      guard let date = calendar.date(from: dc) else {
        XCTFail("Could not form date for \(year)-\(month)-\(day)")
        continue
      }

      // Extract just year & month so yueZhi/yueGan work off those
      let comps = date.dateComponentsFromChineseCalendar()
      
      XCTAssertEqual(
        comps.yueZhi,
        expectedZhi,
        "For \(year)-\(month)-\(day), yueZhi should be \(expectedZhi) (未), got \(String(describing: comps.yueZhi))"
      )
      XCTAssertEqual(
        comps.yueGan,
        expectedGan,
        "For \(year)-\(month)-\(day), yueGan should be \(expectedGan) (癸), got \(String(describing: comps.yueGan))"
      )
    }
  }
  
  func testRiZhiAndRiGan_OnFixedJune2025Dates() {
    let calendar = Calendar(identifier: .gregorian)
    
    // Test data: (year, month, day, expectedGan, expectedZhi)
    let testCases: [(Int, Int, Int, Tiangan, Dizhi)] = [
      (2025, 6,  9,  .ji, .you),
      (2025, 6, 10,  .geng, .xu),
      (2025, 6, 11,  .xin, .hai),
      (2025, 6, 12,  .ren, .zi),
      (2025, 6, 13,  .kui, .chou),
    ]
    
    for (year, month, day, expectedGan, expectedZhi) in testCases {
      // Build a Date from the components
      var dc = DateComponents()
      dc.year = year
      dc.month = month
      dc.day = day
      
      
      guard let date = calendar.date(from: dc) else {
        XCTFail("Could not form date for \(year)-\(month)-\(day)")
        continue
      }

      // Extract just year & month so yueZhi/yueGan work off those

      let comps = calendar.dateComponents([.year, .month, .day], from: date)

      XCTAssertEqual(
        comps.riZhi,
        expectedZhi,
        "For \(year)-\(month)-\(day), rizhi should be \(expectedZhi), got \(String(describing: comps.riZhi))"
      )
      XCTAssertEqual(
        comps.riGan,
        expectedGan,
        "For \(year)-\(month)-\(day), rigan should be \(expectedGan), got \(String(describing: comps.riGan))"
      )
    }
  }
}
