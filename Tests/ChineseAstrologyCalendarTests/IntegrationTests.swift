
//  Created by 孙翔宇 on 03/07/2020.
//

import XCTest
@testable import ChineseAstrologyCalendar

final class IntegrationTests: XCTestCase {

  var date: Date!

  func testNianGanToBeYi() {
    setupDateOne()
    XCTAssertEqual(date.dateComponentsFromCurrentCalendar.nianGan, Tiangan.yi)
  }

  func testNianGan() {
    let calendar = Calendar(identifier: .gregorian)
    let timeZone = TimeZone.chinaStandardTime
    let comp = DateComponents(calendar: calendar, timeZone: timeZone, year: 2021, month: 1, day: 10)
    date = calendar.date(from: comp)
    XCTAssertEqual(date.dateComponentsFromChineseCalendar().nianZhi, Dizhi.zi)
    XCTAssertEqual(date.dateComponentsFromChineseCalendar().nianGan, Tiangan.geng)
    XCTAssertEqual(date.dateComponentsFromChineseCalendar().yueZhi, Dizhi.zi)
  }

  func testNianZhiToBeWei() {
    setupDateOne()
    XCTAssertEqual(date.dateComponentsFromCurrentCalendar.nianZhi, Dizhi.wei)
  }

  func testYuezhiToBeShen() {
    setupDateOne()
    XCTAssertEqual(date.dateComponentsFromChineseCalendar().yueZhi, Dizhi.wu)
  }

  func testYueGanToBeJia() {
    setupDateOne()
    XCTExpectFailure(strict: true) {
      XCTAssertEqual(date.dateComponentsFromChineseCalendar().yueGan, Tiangan.kui)
    }
  }

  func testYuezhiToBeHai() {
    setupDateTwo()
    XCTAssertEqual(date.dateComponentsFromChineseCalendar().yueZhi, Dizhi.you)
  }

  func testYueGanToBeXin() {
    setupDateTwo()
    XCTAssertEqual(date.dateComponentsFromChineseCalendar().yueGan, Tiangan.xin)
  }

  func testNianGanToBeRen() {
    setupDateThree()
    XCTAssertEqual(date.dateComponentsFromCurrentCalendar.nianGan, Tiangan.ren)
  }

  func testNianZhiToBeZi() {
    setupDateThree()
    XCTAssertEqual(date.dateComponentsFromCurrentCalendar.nianZhi, Dizhi.zi)
  }

  func setupDateOne() {
    let calendar = Calendar(identifier: .gregorian)
    let timeZone = TimeZone.chinaStandardTime
    let comp = DateComponents(calendar: calendar, timeZone: timeZone, year: 2015, month: 7, day: 3)
    date = calendar.date(from: comp)
  }

  func setupDateTwo() {
    let calendar = Calendar(identifier: .gregorian)
    let timeZone = TimeZone.chinaStandardTime
    let comp = DateComponents(calendar: calendar, timeZone: timeZone, year: 2012, month: 10, day: 3)
    date = calendar.date(from: comp)
  }

  func setupDateThree() {
    let calendar = Calendar(identifier: .gregorian)
    let timeZone = TimeZone.chinaStandardTime
    let comp = DateComponents(calendar: calendar, timeZone: timeZone, year: 1912, month: 2, day: 18)
    date = calendar.date(from: comp)
  }

}
