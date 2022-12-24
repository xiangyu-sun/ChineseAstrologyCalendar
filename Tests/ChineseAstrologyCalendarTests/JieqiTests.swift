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

}
