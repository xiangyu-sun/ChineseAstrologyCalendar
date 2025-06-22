import XCTest
@testable import ChineseAstrologyCalendar

final class WuxingAdditionalTests: XCTestCase {

  func testShengCycle() {
    XCTAssertEqual(Wuxing.mu.sheng, .huo)
    XCTAssertEqual(Wuxing.huo.sheng, .tu)
    XCTAssertEqual(Wuxing.tu.sheng, .jin)
    XCTAssertEqual(Wuxing.jin.sheng, .shui)
    XCTAssertEqual(Wuxing.shui.sheng, .mu)
  }

  func testColorsAndFlavors() {
    XCTAssertEqual(Wuxing.mu.colorDescription, "青")
    XCTAssertEqual(Wuxing.jin.colorDescription, "白")
    XCTAssertEqual(Wuxing.huo.fiveFlavor, "苦")
  }

  func testFangWei() {
    XCTAssertEqual(Wuxing.mu.fangwei, .dong)
    XCTAssertEqual(Wuxing.tu.fangwei, .zhong)
  }
}
