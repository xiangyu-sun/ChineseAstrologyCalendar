import XCTest
@testable import ChineseAstrologyCalendar

final class ChineseAstrologyCalendarTests: XCTestCase {

    static var allTests = [
        ("testNianGanToNotbeNil", testNianGanToNotbeNil),
    ]
    
    
    func testNianGanToNotbeNil() {
        XCTAssertNotNil(Date().nianGan)
    }
    
    func testNianGanList() {
        for i in 1...10 {
            XCTAssertNotNil(Tiangan(rawValue: i))
        }
    }
    func testNianZhiToNotbeNil() {
        XCTAssertNotNil(Date().nianZhi)
    }
    
    func testNianZhiList() {
        for i in 1...12 {
            XCTAssertNotNil(Dizhi(rawValue: i))
        }
    }
}
