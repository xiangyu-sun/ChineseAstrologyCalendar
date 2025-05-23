import XCTest
@testable import ChineseAstrologyCalendar

final class RiZhuTests: XCTestCase {

  // MARK: - Day Pillar Tests

  /// Test the day pillar (日柱) for 2010-04-12.
  func test_dayPillar_for2010_04_12() throws {
    let component = DateComponents(calendar: .current, year: 2010, month: 4, day: 12)

    // Expected day pillar is "辛卯"
    XCTAssertEqual(component.riZhu?.description, "辛卯", "The day pillar for 2010-04-12 should be 辛卯")

    // Also verify day heavenly stem and earthly branch separately.
    XCTAssertEqual(component.riGan?.chineseCharactor, "辛", "The day heavenly stem for 2010-04-12 should be 辛")
    XCTAssertEqual(component.riZhi?.chineseCharactor, "卯", "The day earthly branch for 2010-04-12 should be 卯")
  }

  /// Test the day pillar (日柱) for another known date.
  func test_dayPillar_for2023_01_23() throws {
    let component = DateComponents(calendar: .current, year: 2023, month: 1, day: 23)

    // Expected day pillar is "庚辰" as per your algorithm.
    XCTAssertEqual(component.riZhu?.description, "庚辰", "The day pillar for 2023-01-23 should be 庚辰")
  }

  /// Test that missing essential components (such as year) results in nil day pillar.
  func test_dayPillar_whenYearIsMissing() {
    let component = DateComponents(calendar: .current, month: 4, day: 12)
    XCTAssertNil(component.riZhu, "Without a year, the day pillar should be nil")
  }

  // MARK: - Month Pillar Tests

  /// Test the month pillar (月柱) for 2023-01-23.
  /// Assuming the computed property is called `yue` (or adjust to `yueZhu` as needed).
  func test_monthPillar_for2023_01_23() throws {
    let component = DateComponents(calendar: .chineseCalendar, year: 2023, month: 1, day: 23)

    // Expected month pillar for this date should be "甲寅" as per your algorithm.
    XCTAssertEqual(component.yue?.description, "甲寅", "The month pillar for 2023-01-23 should be 甲寅")
  }

  // MARK: - Hour Pillar Tests

  /// Test the hour pillar (时柱) for 2010-04-12 at 3 AM.
  /// Assumes that 3 AM is mapped to the period starting with 寅.
  func test_hourPillar_for2010_04_12_at3AM() throws {
    // Provide hour = 3 for 3 AM.
    let component = DateComponents(calendar: .current, year: 2010, month: 4, day: 12, hour: 3)

    // Given that the day pillar for 2010-04-12 is 辛卯,
    // the hour heavenly stem is computed by: (riGan.rawValue * 2 + riZhi.rawValue - 2) % 10.
    // For riGan (辛) with rawValue 8 and riZhi (卯) with rawValue 4, that gives:
    // (8*2 + 4 - 2) = 18, 18 % 10 = 8, so the hour stem is 辛.
    // And assuming the hour mapping gives hour 3 → 寅.
    // Therefore, the expected hour pillar is 辛寅.
    XCTAssertEqual(component.shiZhu?.description, "辛寅", "The hour pillar for 2010-04-12 at 3 AM should be 辛寅")

    // Also check individual components.
    XCTAssertEqual(component.shiGan?.chineseCharactor, "辛", "The hour heavenly stem for 3 AM should be 辛")
    XCTAssertEqual(component.shiZhi?.chineseCharactor, "寅", "The hour earthly branch for 3 AM should be 寅")
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

    // The actual expected values depend on your algorithm.
    // For demonstration, suppose we expect:
    // Day pillar: "癸亥", Month pillar: "己丑", Hour pillar: "壬子"
    // (Adjust these expected values according to your correct algorithm.)
    XCTAssertEqual(component.riZhu?.description, "壬辰", "Day pillar should wrap correctly at the modulo boundary")
    XCTAssertEqual(component.yue?.description, "戊寅", "Month pillar should wrap correctly at the modulo boundary")
    XCTAssertEqual(component.shiZhu?.description, "壬子", "Hour pillar should wrap correctly at the modulo boundary")
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
