//  Created by 孙翔宇 on 03/07/2020.
//  Copyright © 2020 孙翔宇. All rights reserved.
//

import Foundation

extension Date {
  /// Chinese day and month string in the current time zone.
  public var chineseDate: String {
    let dateInChinese = DateFormatter.chineseTranditionalChineseDateFormatter.string(from: self)
    guard let index = dateInChinese.firstIndex(of: "月") else { return "" }
    let start = index.utf16Offset(in: dateInChinese) + 1

    return String(dateInChinese[.init(utf16Offset: start, in: dateInChinese)...])
  }

  /// Chinese year, month and day string in the current time zone.
  public var chineseYearMonthDate: String {
    let dateInChinese = DateFormatter.chineseTranditionalChineseDateFormatter.string(from: self)

    return String(dateInChinese[String.Index(utf16Offset: 4, in: dateInChinese)..<dateInChinese.endIndex])
  }

  /// Year-month-date string with zodiac animal inserted.
  public var displayStringOfChineseYearMonthDateWithZodiac: String {
    var result = chineseYearMonthDate

    let dateCompoenent = dateComponentsFromChineseCalendar()

    guard let index = result.firstIndex(of: "年") else { return "" }

    guard let zodiac = (dateCompoenent.zodiac?.rawValue ?? "").first else { return "" }

    result.insert(zodiac, at: index)

    return result
  }

  /// Chinese date string using China Standard Time.
  public var chineseDateGTM8: String {
    let dateInChinese = DateFormatter.chineseTranditionalChineseDateFormatterWithGTM8.string(from: self)
    guard let index = dateInChinese.firstIndex(of: "月") else { return "" }
    let start = index.utf16Offset(in: dateInChinese) + 1

    return String(dateInChinese[.init(utf16Offset: start, in: dateInChinese)...])
  }

  /// Chinese year-month-date string using China Standard Time.
  public var chineseYearMonthDateGTM8: String {
    let dateInChinese = DateFormatter.chineseTranditionalChineseDateFormatterWithGTM8.string(from: self)

    return String(dateInChinese[String.Index(utf16Offset: 4, in: dateInChinese)..<dateInChinese.endIndex])
  }

  /// Year-month-date string with zodiac using China Standard Time.
  public var displayStringOfChineseYearMonthDateWithZodiacGTM8: String {
    var result = chineseYearMonthDateGTM8

    let dateComponent = dateComponentsFromChineseCalendar(.chineseCalendarGTM8)

    guard let index = result.firstIndex(of: "年") else { return "" }

    guard let zodiac = (dateComponent.zodiac?.rawValue ?? "").first else { return "" }

    result.insert(zodiac, at: index)

    return result
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
