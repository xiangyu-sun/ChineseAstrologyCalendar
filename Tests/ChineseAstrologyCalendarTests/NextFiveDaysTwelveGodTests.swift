//
//  NextFiveDaysTwelveGodTests.swift
//  ChineseAstrologyCalendar
//
//  Created by Xiangyu Sun on 24/6/25.
//


import XCTest
@testable import ChineseAstrologyCalendar

class NextFiveDaysTwelveGodTests: XCTestCase {
  
  func testTwelveGodsForNextFiveDays() {
    let df = DateFormatter()
    df.calendar = Calendar(identifier: .gregorian)
    df.dateFormat = "yyyy-MM-dd"
    
    // 2025-06-24 → 破
    let date1 = df.date(from: "2025-06-24")!
    XCTAssertEqual(date1.twelveGod(), .po, "2025-06-24 should be 破")
    
    // 2025-06-25 → 危
    let date2 = df.date(from: "2025-06-25")!
    XCTAssertEqual(date2.twelveGod(), .wei, "2025-06-25 should be 危")
    
    // 2025-06-26 → 成
    let date3 = df.date(from: "2025-06-26")!
    XCTAssertEqual(date3.twelveGod(), .cheng, "2025-06-26 should be 成")
    
    // 2025-06-27 → 收
    let date4 = df.date(from: "2025-06-27")!
    XCTAssertEqual(date4.twelveGod(), .shou, "2025-06-27 should be 收")
    
    // 2025-06-28 → 開
    let date5 = df.date(from: "2025-06-28")!
    XCTAssertEqual(date5.twelveGod(), .kai, "2025-06-28 should be 開")
  }
}
