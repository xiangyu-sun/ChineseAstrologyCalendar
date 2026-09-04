import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct ShiZhuTests {

  // MARK: - Standard Hour Pillar Tests

  /// Test the hour pillar for 2010-04-12 at 3 AM.
  ///
  /// The actual day pillar for 2010-04-12 is 壬辰 (壬 = 9, verified against
  /// `RiZhuTests.dayPillar_for2010_04_12`). Hour 3 maps to 寅 (rawValue 3).
  /// shiGan = ((9-1)*2 + (3-1)) % 10 + 1 = 18 % 10 + 1 = 9 → 壬.
  /// Thus the hour pillar is "壬寅".
  @Test func shizhu_for_3AM() throws {
    let calendar = Calendar(identifier: .gregorian)
    let component = DateComponents(calendar: calendar, year: 2010, month: 4, day: 12, hour: 3)

    #expect(component.shiZhu?.description == "壬寅", "Hour pillar for 3 AM should be 壬寅")
  }

  /// Test the hour pillar for 2010-04-12 at 11 PM.
  ///
  /// Day pillar is 壬辰 (壬 = 9). Hour 23 maps to 子 (rawValue 1).
  /// shiGan = ((9-1)*2 + (1-1)) % 10 + 1 = 16 % 10 + 1 = 7 → 庚.
  /// Thus the expected hour pillar is "庚子".
  @Test func shizhu_for_11PM() throws {
    let calendar = Calendar(identifier: .gregorian)
    let component = DateComponents(calendar: calendar, year: 2010, month: 4, day: 12, hour: 23)

    #expect(component.shiZhu?.description == "庚子", "Hour pillar for 11 PM should be 庚子")
  }

  // MARK: - Default Hour Tests

  /// Test the hour pillar when the hour component is missing.
  ///
  /// `shiGan` now depends on the hour's own branch (`shiZhi`), which is `nil`
  /// when the hour is missing — so `shiGan` and `shiZhu` must both be `nil`
  /// too, not silently computed from the day alone.
  @Test func shizhu_whenHourIsMissing() throws {
    let calendar = Calendar(identifier: .gregorian)
    let component = DateComponents(calendar: calendar, year: 2010, month: 4, day: 12)

    #expect(component.shiZhi?.chineseCharactor == nil, "Missing hour nil")
    #expect(component.shiGan == nil, "Hour heavenly stem should be nil without an hour")
    #expect(component.shiZhu?.description == nil, "Hour pillar for missing hour should be nil")
  }

  // MARK: - Boundary Hour Tests

  /// Test the hour pillar for midnight (0 hour).
  ///
  /// Day pillar is 壬辰 (壬 = 9). Hour 0 maps to 子 (rawValue 1), same branch
  /// as 11 PM, giving the same stem: shiGan = 7 → 庚.
  @Test func shizhu_for_midnight() throws {
    let calendar = Calendar(identifier: .gregorian)
    let component = DateComponents(calendar: calendar, year: 2010, month: 4, day: 12, hour: 0)

    #expect(component.shiZhu?.description == "庚子", "Hour pillar for midnight should be 庚子")
    #expect(component.shiZhi?.chineseCharactor == "子", "Hour earthly branch for midnight should be 子")
  }

  /// Test the hour pillar for noon (12 PM).
  ///
  /// Day pillar is 壬辰 (壬 = 9). Hour 12 maps to 午 (rawValue 7).
  /// shiGan = ((9-1)*2 + (7-1)) % 10 + 1 = 22 % 10 + 1 = 3 → 丙.
  @Test func shizhu_for_noon() throws {
    let calendar = Calendar(identifier: .gregorian)
    let component = DateComponents(calendar: calendar, year: 2010, month: 4, day: 12, hour: 12)

    #expect(component.shiZhu?.description == "丙午", "Hour pillar for noon should be 丙午")
    #expect(component.shiZhi?.chineseCharactor == "午", "Hour earthly branch for noon should be 午")
  }
}
