import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct DateComponentsMonthTests {

  // MARK: - yueZhi Tests

  @Test func yueZhiValidMonths() {
    let orderedBranches = Dizhi.orderedMonthAlCases // expected order: [寅, 卯, 辰, 巳, 午, 未, 申, 酉, 戌, 亥, 子, 丑]

    for month in 1...12 {
      var comps = DateComponents()
      comps.month = month

      let branch = try? #require(comps.yueZhi)
      if let branch {
        #expect(
          branch == orderedBranches[month - 1],
          "For month \(month), yueZhi should be \(orderedBranches[month - 1]) but got \(branch)")
      }
    }
  }

  @Test func yueZhiInvalidMonth() {
    var comps = DateComponents()
    comps.month = 0
    #expect(comps.yueZhi == nil)

    comps.month = -3
    #expect(comps.yueZhi == nil)

    comps.month = 13
    #expect(comps.yueZhi == nil)
  }

  // MARK: - yueGan Tests

  @Test func yueGanFormula() throws {
    // Use 1984 to yield a nianGan of 1 (甲).
    var comps = components(year: 1984, month: 1, day: 1)

    // nianGan is now computed from the year; verify that it is as expected.
    let nianGan = try #require(comps.nianGan)
    #expect(nianGan == Tiangan(rawValue: 1))

    // Retrieve the branch for month 1.
    let branch = try #require(comps.yueZhi)

    let expectedRaw = (nianGan.rawValue * 2 + branch.monthIndex) % 10
    // Remap a result of 0 to 10.
    let remappedRaw = (expectedRaw == 0 ? 10 : expectedRaw)
    let expectedYueGan = Tiangan(rawValue: remappedRaw)

    #expect(
      comps.yueGan == expectedYueGan,
      "For nianGan \(nianGan) and month 1 (branch \(branch)), expected yueGan to be \(expectedYueGan?.chineseCharactor ?? "nil"), got \(comps.yueGan?.chineseCharactor ?? "nil")")
  }

  @Test func yueGanModuloZeroMapping() {
    // Use 1984 to have nianGan = 1.
    var comps = DateComponents()
    comps.calendar = Calendar(identifier: .chinese)
    comps.year = 1984
    comps.month = 8
    comps.day = 28

    // For month 8, assume the computed yueZhi has raw value 8.
    // Expected: (1*2 + 8) = 10, 10 % 10 == 0, then remapped to 10.
    let expectedYueGan = Tiangan(rawValue: 10)
    #expect(
      comps.yueGan == expectedYueGan,
      "When modulo result is 0, yueGan should be remapped to 10. Expected \(expectedYueGan?.chineseCharactor ?? "nil"), got \(comps.yueGan?.chineseCharactor ?? "nil")")
  }

  // MARK: - yueZhu Tests

  @Test func yueZhuCombination() throws {
    // Use 1984 to yield nianGan = 1.
    var comps = components(year: 1984, month: 1, day: 1)

    // Calculate expected yueGan using the same formula:
    let branch = try #require(comps.yueZhi)
    let nianGan = try #require(comps.nianGan)

    let rawValueCalc = (nianGan.rawValue * 2 + branch.monthIndex) % 10
    let finalRaw = rawValueCalc == 0 ? 10 : rawValueCalc
    let expectedYueGan = Tiangan(rawValue: finalRaw)!

    let expectedYueZhu = Ganzhi(gan: expectedYueGan, zhi: branch)

    #expect(
      comps.yueZhu == expectedYueZhu,
      "yueZhu should be the combination of yueGan (\(expectedYueGan.chineseCharactor)) and yueZhi (\(branch.chineseCharactor)).")
  }

  @Test func yueZhuMissingComponents() {
    // Case 1: Year is missing (so nianGan cannot be computed).
    var comps = DateComponents()
    comps.month = 5
    #expect(comps.yueZhu == nil)

    // Case 2: Month is missing (so yueZhi cannot be computed).
    comps = components(year: 1984)
    #expect(comps.yueZhu == nil)
  }

  // MARK: - Helper

  private func components(year: Int, month: Int? = nil, day: Int? = nil) -> DateComponents {
    var comps = DateComponents()
    comps.calendar = Calendar(identifier: .gregorian)
    comps.year = year
    comps.month = month
    comps.day = day
    return comps
  }

}
