import XCTest
@testable import ChineseAstrologyCalendar

final class ShichenAdditionalTests: XCTestCase {

  func testNextStartDateAndCurrentKe() {
    var components = DateComponents()
    components.year = 2023
    components.month = 5
    components.day = 27
    components.hour = 9
    components.minute = 45
    let date = Calendar.current.date(from: components)!

    let shichen = Shichen(dizhi: .si, date: date)

    let start = Calendar.current.dateComponents([.hour, .minute], from: shichen.startDate)
    XCTAssertEqual(start.hour, 9)
    XCTAssertEqual(start.minute, 0)

    let next = Calendar.current.dateComponents([.hour, .minute], from: shichen.nextStartDate)
    XCTAssertEqual(next.hour, 11)
    XCTAssertEqual(next.minute, 0)

    XCTAssertEqual(shichen.currentKe, 3)
  }
  
  // MARK: - Ke Logic Tests
  
  func testKeLength() {
    // Test that ke length constant is correct (15 minutes = 900 seconds)
    XCTAssertEqual(Shichen.keLength, 900.0)
    
    // Test instance accessor
    let shichen = Shichen(dizhi: .zi, date: Date())
    XCTAssertEqual(shichen.ke, 900.0)
  }
  
  func testCurrentKeAtStartOfShichen() {
    // Date exactly at the start of a Shichen should be ke 0
    var components = DateComponents()
    components.year = 2023
    components.month = 6
    components.day = 15
    components.hour = 9  // Start of Si hour (巳時)
    components.minute = 0
    components.second = 0
    let date = Calendar.current.date(from: components)!
    
    let shichen = Shichen(dizhi: .si, date: date)
    XCTAssertEqual(shichen.currentKe, 0, "At start of Shichen, ke should be 0")
  }
  
  func testCurrentKeProgressionThroughShichen() {
    let calendar = Calendar.current
    var components = DateComponents()
    components.year = 2023
    components.month = 6
    components.day = 15
    components.hour = 9  // Start of Si hour (巳時)
    components.minute = 0
    components.second = 0
    
    guard let baseDate = calendar.date(from: components) else {
      XCTFail("Could not create base date")
      return
    }
    
    // Test each ke (0-7) within the two-hour period
    let expectedKe = [
      (0, 0),    // 09:00 - ke 0
      (14, 0),   // 09:14 - ke 0
      (15, 1),   // 09:15 - ke 1
      (30, 2),   // 09:30 - ke 2
      (45, 3),   // 09:45 - ke 3
      (60, 4),   // 10:00 - ke 4
      (75, 5),   // 10:15 - ke 5
      (90, 6),   // 10:30 - ke 6
      (105, 7),  // 10:45 - ke 7
    ]
    
    for (minutes, expected) in expectedKe {
      let testDate = baseDate.addingTimeInterval(TimeInterval(minutes * 60))
      let shichen = Shichen(dizhi: .si, date: testDate)
      XCTAssertEqual(
        shichen.currentKe,
        expected,
        "At \(minutes) minutes into Shichen, ke should be \(expected)"
      )
    }
  }
  
  func testCurrentKeAtEndOfShichen() {
    // Date near the end of a Shichen should be ke 7
    var components = DateComponents()
    components.year = 2023
    components.month = 6
    components.day = 15
    components.hour = 10  // Near end of Si hour (巳時 ends at 11:00)
    components.minute = 59
    components.second = 59
    let date = Calendar.current.date(from: components)!
    
    let shichen = Shichen(dizhi: .si, date: date)
    XCTAssertEqual(shichen.currentKe, 7, "Near end of Shichen, ke should be 7")
  }
  
  func testCurrentKeForZiHour() {
    // Special case: Zi hour (子時) spans midnight (23:00-01:00)
    var components = DateComponents()
    components.year = 2023
    components.month = 6
    components.day = 15
    components.hour = 23  // Start of Zi hour
    components.minute = 30  // 30 minutes in = ke 2
    components.second = 0
    let date = Calendar.current.date(from: components)!
    
    let shichen = Shichen(dizhi: .zi, date: date)
    XCTAssertEqual(shichen.currentKe, 2, "At 23:30 during Zi hour, ke should be 2")
  }
  
  func testCurrentKeAfterMidnightInZiHour() {
    // Test Zi hour after midnight
    var components = DateComponents()
    components.year = 2023
    components.month = 6
    components.day = 16
    components.hour = 0   // After midnight, still in Zi hour
    components.minute = 30  // Should be ke 6 (90 minutes from 23:00)
    components.second = 0
    let date = Calendar.current.date(from: components)!
    
    let shichen = Shichen(dizhi: .zi, date: date)
    XCTAssertEqual(shichen.currentKe, 6, "At 00:30 during Zi hour, ke should be 6")
  }
  
  func testCurrentKeBoundaryChecking() {
    // Test that currentKe never goes below 0 or above 7
    var components = DateComponents()
    components.year = 2023
    components.month = 6
    components.day = 15
    components.hour = 9
    components.minute = 0
    
    guard let baseDate = Calendar.current.date(from: components) else {
      XCTFail("Could not create base date")
      return
    }
    
    // Test at exact boundary (last second of last ke)
    let lastKeMoment = baseDate.addingTimeInterval(119 * 60 + 59) // 1:59:59 into period
    let shichenAtEnd = Shichen(dizhi: .si, date: lastKeMoment)
    XCTAssertEqual(shichenAtEnd.currentKe, 7, "At last moment of Shichen, ke should be 7")
    
    // Verify ke stays in range
    XCTAssertGreaterThanOrEqual(shichenAtEnd.currentKe, 0, "Ke should never be less than 0")
    XCTAssertLessThanOrEqual(shichenAtEnd.currentKe, 7, "Ke should never be greater than 7")
  }
  
  func testCurrentKeWithDifferentDizhi() {
    // Test ke calculation across different Dizhi periods
    let calendar = Calendar.current
    var components = DateComponents()
    components.year = 2023
    components.month = 6
    components.day = 15
    
    let testCases: [(dizhi: Dizhi, hour: Int, minute: Int, expectedKe: Int)] = [
      (.zi, 23, 15, 1),   // 子時 23:15
      (.chou, 1, 30, 2),  // 丑時 01:30
      (.yin, 3, 45, 3),   // 寅時 03:45
      (.mao, 6, 0, 4),    // 卯時 06:00 (4th ke)
      (.chen, 7, 15, 1),  // 辰時 07:15
      (.wu, 11, 30, 2),   // 午時 11:30
      (.wei, 13, 45, 3),  // 未時 13:45
      (.shen, 15, 0, 0),  // 申時 15:00
      (.you, 17, 15, 1),  // 酉時 17:15
      (.xu, 19, 30, 2),   // 戌時 19:30
      (.hai, 21, 45, 3),  // 亥時 21:45
    ]
    
    for testCase in testCases {
      components.hour = testCase.hour
      components.minute = testCase.minute
      components.second = 0
      
      guard let date = calendar.date(from: components) else {
        XCTFail("Could not create date for \(testCase.dizhi)")
        continue
      }
      
      let shichen = Shichen(dizhi: testCase.dizhi, date: date)
      XCTAssertEqual(
        shichen.currentKe,
        testCase.expectedKe,
        "At \(testCase.hour):\(testCase.minute) during \(testCase.dizhi), ke should be \(testCase.expectedKe)"
      )
    }
  }
  
  func testKeLengthConsistency() {
    // Verify that 8 ke periods = 2 hours = 7200 seconds
    let totalSeconds = Shichen.keLength * 8
    XCTAssertEqual(totalSeconds, 7200, "8 ke periods should equal 2 hours (7200 seconds)")
  }
}
