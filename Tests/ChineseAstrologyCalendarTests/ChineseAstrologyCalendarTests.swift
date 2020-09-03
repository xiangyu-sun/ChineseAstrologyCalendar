import XCTest
@testable import ChineseAstrologyCalendar

final class ChineseAstrologyCalendarTests: XCTestCase {

    static var allTests = [
        ("testNianGanToNotbeNil", testNianGanToNotbeNil),
    ]
    
    
    func testNianGanToNotbeNil() {
        XCTAssertNotNil(Date().nianGan)
    }
    
    func testNianGanListHasTenElements() {
        for i in 1...10 {
            XCTAssertNotNil(Tiangan(rawValue: i))
        }
    }
    func testNianZhiToNotbeNil() {
        XCTAssertNotNil(Date().nianZhi)
    }
    
    func testNianZhiListHasTwelveElements() {
        for i in 1...12 {
            XCTAssertNotNil(Dizhi(rawValue: i))
        }
    }
    
    func testYuezhiToNotBeNil() {
        XCTAssertNotNil(Date().yueZhi)
    }
    
    func testYueGanToNotBeNil() {
         XCTAssertNotNil(Date().yueZhi)
     }
    
    func testTimeInterval() throws {
        let dizhi = try GanzhiDateConverter.shichen(Date())
        XCTAssertGreaterThan(dizhi.secondToNextShiChen(), 0)
    }
}
