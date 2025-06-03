import XCTest
@testable import ChineseAstrologyCalendar

final class DateComponentsMonthTests: XCTestCase {

  // MARK: Internal

  // MARK: - yueZhi Tests

  /// Test that for valid months (1 to 12), yueZhi returns the expected branch.
  func testYueZhiValidMonths() {
    let orderedBranches = Dizhi.orderedMonthAlCases // expected order: [寅, 卯, 辰, 巳, 午, 未, 申, 酉, 戌, 亥, 子, 丑]

    for month in 1...12 {
      var comps = DateComponents()
      comps.month = month

      guard let branch = comps.yueZhi else {
        XCTFail("yueZhi should not be nil for month \(month)")
        continue
      }
      XCTAssertEqual(
        branch,
        orderedBranches[month - 1],
        "For month \(month), yueZhi should be \(orderedBranches[month - 1]) but got \(branch)")
    }
  }

  /// Test that yueZhi returns nil when month is invalid (0 or negative).
  func testYueZhiInvalidMonth() {
    var comps = DateComponents()
    comps.month = 0
    XCTAssertNil(comps.yueZhi, "yueZhi should be nil for month 0")

    comps.month = -3
    XCTAssertNil(comps.yueZhi, "yueZhi should be nil for a negative month")

    comps.month = 13
    XCTAssertNil(comps.yueZhi, "yueZhi should be nil for month greater than 12")
  }

  // MARK: - yueGan Tests

  /// Test the yueGan calculation given a known year (to yield a known nianGan) and month.
  ///
  /// Assumption:
  /// - We use 1984 as the test year because 1984 is traditionally a 甲 year (nianGan = Tiangan(rawValue: 1)).
  /// - For month 1, assume that orderedMonthAlCases[0] is 寅 with raw value 1.
  ///   Then the formula is: (nianGan.rawValue * 2 + yueZhi.rawValue) % 10.
  ///   With nianGan = 1 and yueZhi raw value = 1, we get (1*2 + 1) % 10 = 3.
  ///   So yueGan should be Tiangan(rawValue: 3).
  func testYueGanFormula() {
    // Use 1984 to yield a nianGan of 1 (甲).
    var comps = components(year: 1984, month: 1, day: 1)

    // nianGan is now computed from the year; verify that it is as expected.
    guard let nianGan = comps.nianGan else {
      XCTFail("nianGan should not be nil for a valid year")
      return
    }
    XCTAssertEqual(nianGan, Tiangan(rawValue: 1), "nianGan for 1984 should be 甲 (raw value 1)")

    // Retrieve the branch for month 1.
    guard let branch = comps.yueZhi else {
      XCTFail("Expected a valid yueZhi for month 1")
      return
    }

    let expectedRaw = (nianGan.rawValue * 2 + branch.monthIndex) % 10
    // Remap a result of 0 to 10.
    let remappedRaw = (expectedRaw == 0 ? 10 : expectedRaw)
    let expectedYueGan = Tiangan(rawValue: remappedRaw)

    XCTAssertEqual(
      comps.yueGan,
      expectedYueGan,
      "For nianGan \(nianGan) and month 1 (branch \(branch)), expected yueGan to be \(expectedYueGan?.chineseCharactor ?? "nil"), got \(comps.yueGan?.chineseCharactor ?? "nil")")
  }

  /// Test a case where the modulo yields 0 so that it is remapped to 10.
  ///
  /// For example, if nianGan.rawValue = 1 (using 1984) and we choose a month whose branch has raw value 8,
  /// then (1*2 + 8) = 10 and 10 % 10 == 0, which should be remapped to 10.
  /// We assume that month 8 gives yueZhi with raw value 8.
  func testYueGanModuloZeroMapping() {
    // Use 1984 to have nianGan = 1.
    var comps = DateComponents()
    comps.calendar = Calendar(identifier: .chinese)
    comps.year = 1984
    comps.month = 8
    comps.day = 28

    // For month 8, assume the computed yueZhi has raw value 8.
    // Expected: (1*2 + 8) = 10, 10 % 10 == 0, then remapped to 10.
    let expectedYueGan = Tiangan(rawValue: 10)
    XCTAssertEqual(
      comps.yueGan,
      expectedYueGan,
      "When modulo result is 0, yueGan should be remapped to 10. Expected \(expectedYueGan?.chineseCharactor ?? "nil"), got \(comps.yueGan?.chineseCharactor ?? "nil")")
  }

  // MARK: - yueZhu Tests

  /// Test that yueZhu correctly combines yueGan and yueZhi.
  func testYueZhuCombination() {
    // Use 1984 to yield nianGan = 1.
    var comps = components(year: 1984, month: 1, day: 1)

    // Calculate expected yueGan using the same formula:
    guard let branch = comps.yueZhi else {
      XCTFail("Expected yueZhi for month 1")
      return
    }
    guard let nianGan = comps.nianGan else {
      XCTFail("Expected nianGan for a valid year")
      return
    }

    let rawValueCalc = (nianGan.rawValue * 2 + branch.monthIndex) % 10
    let finalRaw = rawValueCalc == 0 ? 10 : rawValueCalc
    let expectedYueGan = Tiangan(rawValue: finalRaw)!

    let expectedYueZhu = Ganzhi(gan: expectedYueGan, zhi: branch)

    XCTAssertEqual(
      comps.yueZhu,
      expectedYueZhu,
      "yueZhu should be the combination of yueGan (\(expectedYueGan.chineseCharactor)) and yueZhi (\(branch.chineseCharactor)).")
  }

  /// Test that yueZhu returns nil when either nianGan or month (thus yueZhi) is missing.
  func testYueZhuMissingComponents() {
    // Case 1: Year is missing (so nianGan cannot be computed).
    var comps = DateComponents()
    comps.month = 5
    XCTAssertNil(comps.yueZhu, "yueZhu should be nil when year (and thus nianGan) is missing")

    // Case 2: Month is missing (so yueZhi cannot be computed).
    comps = components(year: 1984)
    XCTAssertNil(comps.yueZhu, "yueZhu should be nil when month is missing")
  }

  // MARK: Private

  // MARK: - Helper

  /// Returns a DateComponents value for the given Gregorian date.
  /// (This helps ensure that the computed properties use a Gregorian calendar.)
  private func components(year: Int, month: Int? = nil, day: Int? = nil) -> DateComponents {
    var comps = DateComponents()
    comps.calendar = Calendar(identifier: .gregorian)
    comps.year = year
    comps.month = month
    comps.day = day
    return comps
  }

}
