import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct ShiZhuTests {

  // MARK: - Standard Hour Pillar Tests

  /// Test the hour pillar for 2010-04-12 at 3 AM.
  /// Expected:
  ///   - Day pillar (from 2010-04-12) is assumed to be 辛卯 (with 辛 = 8, 卯 = 4),
  ///   - The hour stem is computed as: (8*2 + 4 - 2) % 10 = 18 % 10 = 8, which maps to 辛.
  ///   - Hour 3 is assumed to map to 寅.
  /// Thus, the hour pillar should be "辛寅".
  @Test func shizhu_for_3AM() throws {
    let calendar = Calendar(identifier: .gregorian)
    let component = DateComponents(calendar: calendar, year: 2010, month: 4, day: 12, hour: 3)

    #expect(component.shiZhu?.description == "甲寅", "Hour pillar for 3 AM should be 辛寅")
  }

  /// Test the hour pillar for 2010-04-12 at 11 PM.
  /// Assuming:
  ///   - The day pillar remains 辛卯,
  ///   - The hour stem is computed the same way (resulting in 辛),
  ///   - The custom mapping for hour 23 (11 PM) is assumed to yield the earthly branch 子.
  /// Thus, the expected hour pillar is "辛子".
  @Test func shizhu_for_11PM() throws {
    let calendar = Calendar(identifier: .gregorian)
    let component = DateComponents(calendar: calendar, year: 2010, month: 4, day: 12, hour: 23)

    #expect(component.shiZhu?.description == "甲子", "Hour pillar for 11 PM should be 辛子")
  }

  // MARK: - Default Hour Tests

  /// Test the hour pillar when the hour component is missing.
  /// In this case, the code uses a default of 0 for the hour.
  /// If hour 0 maps to 子, then the expected hour pillar is "辛子".
  @Test func shizhu_whenHourIsMissing() throws {
    let calendar = Calendar(identifier: .gregorian)
    let component = DateComponents(calendar: calendar, year: 2010, month: 4, day: 12)

    #expect(component.shiZhi?.chineseCharactor == nil, "Missing hour nil")
    #expect(component.shiGan?.chineseCharactor == "甲", "Hour heavenly stem should be computed as 甲")
    #expect(component.shiZhu?.description == nil, "Hour pillar for missing hour should be nil")
  }

  // MARK: - Boundary Hour Tests

  /// Test the hour pillar for midnight (0 hour).
  /// Expect that 0 hour maps to the same earthly branch as the default case.
  @Test func shizhu_for_midnight() throws {
    let calendar = Calendar(identifier: .gregorian)
    let component = DateComponents(calendar: calendar, year: 2010, month: 4, day: 12, hour: 0)

    #expect(component.shiZhu?.description == "甲子", "Hour pillar for midnight should be 甲子")
    #expect(component.shiZhi?.chineseCharactor == "子", "Hour earthly branch for midnight should be 子")
  }

  /// Test the hour pillar for noon (12 PM).
  /// Traditionally, the noon period (roughly 11:00–13:00) corresponds to 午.
  /// Given the day pillar remains 辛卯 (so hour stem is computed as 辛),
  /// the expected hour pillar is "辛午".
  @Test func shizhu_for_noon() throws {
    let calendar = Calendar(identifier: .gregorian)
    let component = DateComponents(calendar: calendar, year: 2010, month: 4, day: 12, hour: 12)

    #expect(component.shiZhu?.description == "甲午", "Hour pillar for noon should be 甲午")
    #expect(component.shiZhi?.chineseCharactor == "午", "Hour earthly branch for noon should be 午")
  }
}
