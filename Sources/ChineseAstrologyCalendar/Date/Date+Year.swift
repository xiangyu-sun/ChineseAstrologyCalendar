//  Created by 孙翔宇 on 03/07/2020.
//  Copyright © 2020 孙翔宇. All rights reserved.
//

import Foundation

// MARK: - Deprecated string accessors
//
// These used to cut fixed character offsets out of a DateFormatter's output,
// which broke whenever the OS changed its Chinese-calendar format, and could
// only produce Traditional Chinese. They now render a LunarDate.

extension Date {
  /// Chinese day string in the current time zone, e.g. 初九.
  @available(*, deprecated, message: "Use lunarDate()?.formatted(.day, in:)")
  public var chineseDate: String {
    lunarDate()?.formatted(.day) ?? ""
  }

  /// Chinese year, month and day string in the current time zone, e.g. 壬寅年五月初九.
  @available(*, deprecated, message: "Use lunarDate()?.formatted(.yearMonthDay, in:)")
  public var chineseYearMonthDate: String {
    lunarDate()?.formatted(.yearMonthDay) ?? ""
  }

  /// Year-month-date string with the zodiac animal, e.g. 壬寅虎年五月初九.
  @available(*, deprecated, message: "Use lunarDate()?.formatted(.yearZodiacMonthDay, in:)")
  public var displayStringOfChineseYearMonthDateWithZodiac: String {
    lunarDate()?.formatted(.yearZodiacMonthDay) ?? ""
  }

  /// Chinese day string in China Standard Time, e.g. 初九.
  @available(*, deprecated, message: "Use lunarDate(.chineseCalendarGTM8)?.formatted(.day, in:)")
  public var chineseDateGTM8: String {
    lunarDate(.chineseCalendarGTM8)?.formatted(.day) ?? ""
  }

  /// Chinese year-month-date string in China Standard Time.
  @available(*, deprecated, message: "Use lunarDate(.chineseCalendarGTM8)?.formatted(.yearMonthDay, in:)")
  public var chineseYearMonthDateGTM8: String {
    lunarDate(.chineseCalendarGTM8)?.formatted(.yearMonthDay) ?? ""
  }

  /// Year-month-date string with the zodiac animal in China Standard Time.
  @available(*, deprecated, message: "Use lunarDate(.chineseCalendarGTM8)?.formatted(.yearZodiacMonthDay, in:)")
  public var displayStringOfChineseYearMonthDateWithZodiacGTM8: String {
    lunarDate(.chineseCalendarGTM8)?.formatted(.yearZodiacMonthDay) ?? ""
  }
}
extension DateComponents {

  // MARK: Internal

  /// The Chinese cyclical year number (from 0 to 59) computed from the Gregorian year.
  ///
  /// This value is the remainder after dividing the adjusted year by 60.
  var chineseYear: Int? {
    guard let adjustedYear else {
      return nil
    }
    return adjustedYear % 60
  }

  /// The Chinese era number computed from the Gregorian year.
  ///
  /// This value represents the number of complete 60‑year cycles that have passed.
  var chineseEra: Int? {
    guard let adjustedYear else {
      return nil
    }
    return adjustedYear / 60
  }

  // MARK: Private

  /// Computes the adjusted year by adding the offset between the Gregorian year and the Chinese cyclic calendar.
  ///
  /// - Note: The offset of 2697 is used to align the Gregorian year with the Chinese 60‑year cycle.
  private var adjustedYear: Int? {
    guard let year else {
      return nil
    }
    // If `year` is nil, default to 0.
    return year + 2697
  }

}
