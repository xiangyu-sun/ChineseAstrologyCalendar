//
//  JiaziTests.swift
//
//
//  Created by Xiangyu Sun on 24/12/22.
//

import XCTest
@testable import ChineseAstrologyCalendar

final class JiaziTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testYinYang() {
    for ganzhi in getJiazhi() {
      XCTAssertEqual(ganzhi.gan.yin, ganzhi.zhi.yin)
    }
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    measure {
      XCTAssertEqual(
        getJiazhi().description,
        "[甲子, 乙丑, 丙寅, 丁卯, 戊辰, 己巳, 庚午, 辛未, 壬申, 癸酉, 甲戌, 乙亥, 丙子, 丁丑, 戊寅, 己卯, 庚辰, 辛巳, 壬午, 癸未, 甲申, 乙酉, 丙戌, 丁亥, 戊子, 己丑, 庚寅, 辛卯, 壬辰, 癸巳, 甲午, 乙未, 丙申, 丁酉, 戊戌, 己亥, 庚子, 辛丑, 壬寅, 癸卯, 甲辰, 乙巳, 丙午, 丁未, 戊申, 己酉, 庚戌, 辛亥, 壬子, 癸丑, 甲寅, 乙卯, 丙辰, 丁巳, 戊午, 己未, 庚申, 辛酉, 壬戌, 癸亥]")
    }
  }

}
