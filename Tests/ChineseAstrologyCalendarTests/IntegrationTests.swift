
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
    
    func testNianGan() {
        let calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(abbreviation: "CST")
        let comp = DateComponents(calendar: calendar, timeZone: timeZone, year: 2020, month: 1, day: 10)
        self.date = calendar.date(from: comp)
        XCTAssertEqual(date.nianZhi, Dizhi.zi)
        XCTAssertEqual(date.nianGan, Tiangan.geng)
    }
    
    func testNianZhiToBeWei() {
        setupDateOne()
        XCTAssertEqual(date.nianZhi, Dizhi.wei)
    }
    
    func testYuezhiToBeShen() {
        setupDateOne()
        XCTAssertEqual(date.yueZhi, Dizhi.shen)
    }
    
    func testYueGanToBeJia() {
        setupDateOne()
        XCTAssertEqual(date.yueGan, Tiangan.kui)
    }
    
    
    func testYuezhiToBeHai() {
        setupDateTwo()
        XCTAssertEqual(date.yueZhi, Dizhi.hai)
    }
    
    func testYueGanToBeXin() {
        setupDateTwo()
        XCTAssertEqual(date.yueGan, Tiangan.xin)
    }
    func testNianGanToBeRen() {
        setupDateThree()
        XCTAssertEqual(date.nianGan, Tiangan.ren)
    }
    func testNianZhiToBeZi() {
        setupDateThree()
        XCTAssertEqual(date.nianZhi, Dizhi.zi)
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
    
    func setupDateThree() {
        let calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(abbreviation: "CST")
        let comp = DateComponents(calendar: calendar, timeZone: timeZone, year: 1912, month: 2, day: 18)
        self.date = calendar.date(from: comp)
    }
    
}

