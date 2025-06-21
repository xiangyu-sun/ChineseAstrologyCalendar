import XCTest
@testable import ChineseAstrologyCalendar

final class RiZhuTests: XCTestCase {

  // MARK: - Day Pillar Tests

  /// Test the day pillar (日柱) for 2010-04-12.
    func test_dayPillar_for2010_04_12() throws {
      let component = DateComponents(calendar: .current, year: 2010, month: 4, day: 12)
      XCTAssertEqual(component.riZhu?.description, "壬辰", "The day pillar for 2010-04-12 should be 壬辰")
    }
  
  /// Test the day pillar (日柱) for 2010-04-12.
    func test_dayPillar_for_chineseCalendar_2010_04_12() throws {
      let component = DateComponents(calendar: .chineseCalendar, year: 2010, month: 4, day: 12)
      
      XCTAssertEqual(component.yue?.description, "辛巳", "The month pillar for 2023-01-12 should be 辛巳")
    }

    /// Test the day pillar (日柱) for another known date.
    func test_dayPillar_for2023_01_23() throws {
      let component = DateComponents(calendar: .current, year: 2023, month: 1, day: 23)

      XCTAssertEqual(component.riZhu?.description, "辛巳", "The day pillar for 2023-01-23 should be 辛巳")
    }
  
  /// Test the day pillar (日柱) for another known date.
  func test_dayPilla_chineseCalendar_for2023_01_23() throws {
    let component = DateComponents(calendar: .chineseCalendar, year: 2023, month: 1, day: 23)
    
    XCTAssertEqual(component.yue?.description, "甲寅", "The month pillar for 2023-01-12 should be 甲寅")
  }

  // MARK: - Month Pillar Tests

  /// Test the month pillar (月柱) for 2023-01-23.
  /// Assuming the computed property is called `yue` (or adjust to `yueZhu` as needed).
  func test_monthPillar_for2023_01_23() throws {
    let component = DateComponents(calendar: .chineseCalendar, year: 2023, month: 1, day: 23)

    // Expected month pillar for this date should be "甲寅" as per your algorithm.
    XCTAssertEqual(component.yue?.description, "甲寅", "The month pillar for 2023-01-23 should be 甲寅")
  }
  
  func test_monthPillar_for2025_06_09() throws {
    let date = try XCTUnwrap(Calendar.current.date(from: DateComponents(calendar: .current, year: 2025, month: 06, day: 09)))
    let component = date.dateComponentsFromChineseCalendar()
    
    XCTAssertEqual(component.yue?.description, "壬午", "The month pillar for 2025-06-09 should be 壬午")
  }
  
  func test_yearPillar_for2025_06_09() throws {
    let component = DateComponents(calendar: .current, year: 2025, month: 06, day: 09)
    XCTAssertEqual(component.nian?.description, "乙巳", "The month pillar for 2025-06-09 should be 乙巳")
  }


  // MARK: - Hour Pillar Tests

  /// Test the hour pillar (时柱) for 2010-04-12 at 3 AM.
  /// Assumes that 3 AM is mapped to the period starting with 寅.
  func test_hourPillar_for2010_04_12_at3AM() throws {
    // Provide hour = 3 for 3 AM.
    let component = DateComponents(calendar: .current, year: 2010, month: 4, day: 12, hour: 3)

    XCTAssertEqual(component.shiZhu?.description, "甲寅", "The hour pillar for 2010-04-12 at 3 AM should be 甲寅")
  }

  /// Test the hour pillar when the hour component is missing.
  /// In such a case, a default (e.g. 0 hour) may be assumed.
  func test_hourPillar_whenHourIsMissing() {
    let component = DateComponents(calendar: .current, year: 2010, month: 4, day: 12)

    XCTAssertNil(component.shiZhi, "The hour earthly branch nil when hour is missing")
  }

  // MARK: - Additional Boundary and Consistency Tests

  /// Test that the computed pillars wrap around correctly.
  func test_moduloWrapping() {
    // Create a component with a date that yields a base value near the modulo boundaries.
    let component = DateComponents(calendar: .current, year: 1999, month: 12, day: 29, hour: 23, minute: 59, second: 59)

    XCTAssertEqual(component.riZhu?.description, "乙卯", "Day pillar should wrap correctly at the modulo boundary")
    XCTAssertEqual(component.yue?.description, "丁丑", "Month pillar should wrap correctly at the modulo boundary")
    XCTAssertEqual(component.shiZhu?.description, "己子", "Hour pillar should wrap correctly at the modulo boundary")
  }

  /// Test consistency across different calendars (if applicable).
  func test_withDifferentCalendar() {
    // Create a component using a non-Gregorian calendar if your code supports it.
    // For example, use the Chinese lunar calendar.
    var components = DateComponents()
    components.calendar = Calendar(identifier: .chinese)
    components.year = 2023
    components.month = 1
    components.day = 1

    // The expected result depends on how your algorithm interprets dates in a non-Gregorian calendar.
    // Here we verify that the properties do not crash and return a valid value (or nil if not supported).
    XCTAssertNotNil(components.riZhu, "Day pillar should be computed even for a non-Gregorian calendar if supported")
  }
}
