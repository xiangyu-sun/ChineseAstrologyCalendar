
//  Created by 孙翔宇 on 03/07/2020.
//

import XCTest
@testable import ChineseAstrologyCalendar

final class IntegrationTests: XCTestCase {
    
    var date: Date!
    
    func testNianGanToBeYi() {
        setupDateOne()
        XCTAssertEqual(date.nianGan, Tiangan.yi)
    }
    
    func testNianZhiToBeZhi() {
        setupDateOne()
        XCTAssertEqual(date.nianZhi, Dizhi.wei)
    }
    
    func testYuezhiToBeShen() {
        setupDateOne()
        XCTAssertEqual(date.yueZhi, Dizhi.shen)
    }
    
    func testYueGanToBeJia() {
        setupDateOne()
        XCTAssertEqual(date.yueGan, Tiangan.jia)
    }
    
    
    func testNianGanToBeRen() {
        setupDateTwo()
        XCTAssertEqual(date.nianGan, Tiangan.ren)
    }
    
    func testYuezhiToBeHai() {
        setupDateTwo()
        XCTAssertEqual(date.yueZhi, Dizhi.hai)
    }
    
    func testYueGanToBeXin() {
        setupDateTwo()
        XCTAssertEqual(date.yueGan, Tiangan.xin)
    }
    
    
    func setupDateOne() {
        let calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(abbreviation: "CST")
        let comp = DateComponents(calendar: calendar, timeZone: timeZone, year: 2015, month: 7, day: 3)
        self.date = calendar.date(from: comp)
    }
    
    func setupDateTwo() {
        let calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(abbreviation: "CST")
        let comp = DateComponents(calendar: calendar, timeZone: timeZone, year: 2012, month: 10, day: 3)
        self.date = calendar.date(from: comp)
    }
}

