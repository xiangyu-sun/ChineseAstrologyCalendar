//
//  GanzhiDateConverter.swift
//
//
//  Created by 孙翔宇 on 04/07/2020.
//

import Foundation

// MARK: - GanzhiDateConverter

/// Accessors for Heavenly Stem and Earthly Branch combinations.
extension DateComponents {

  /// ``Ganzhi`` for the year pillar.
  public var nian: Ganzhi? {
    guard let t = nianGan else { return nil }
    guard let d = nianZhi else { return nil }

    return Ganzhi(gan: t, zhi: d)
  }

  /// ``Ganzhi`` for the month pillar.
  public var yue: Ganzhi? {
    guard let t = yueGan else { return nil }
    guard let d = yueZhi else { return nil }

    return Ganzhi(gan: t, zhi: d)
  }

  /// Zodiac animal derived from the year pillar.
  public var zodiac: Zodiac? {
    if let d = nianZhi {
      return Zodiac(d)
    }
    return nil
  }

}

extension Date {
  /// ``Shichen`` calculated using China Standard Time.
  public var shichenGTM8: Shichen? {
    let calendar = Calendar.chineseCalendarGTM8

    let component = calendar.dateComponents(in: calendar.timeZone, from: self)

    guard let hour = component.hour else { return nil }

    return Shichen(dizhi: Dizhi(hourOfDay: hour), date: self)
  }

  /// ``Shichen`` calculated using the current time zone.
  ///
  /// Returns the traditional Chinese 2-hour time period (时辰) for this date.
  /// Each shichen corresponds to one of the 12 Earthly Branches (地支).
  ///
  /// - Returns: The `Shichen` for this date, or `nil` if the hour component cannot be extracted
  ///
  /// - Note: Returns `nil` when the hour component is unavailable from the date.
  ///         Use the current timezone for calculation.
  ///
  /// Example:
  /// ```swift
  /// let date = Date()
  /// if let shichen = date.shichen {
  ///     print("Current period: \(shichen.dizhi.chineseCharacter)")
  ///     print("Started: \(shichen.startDate)")
  ///     print("Ends: \(shichen.endDate)")
  /// }
  /// ```
  public var shichen: Shichen? {
    let calendar = Calendar.chineseCalendar

    let component = calendar.dateComponents(in: TimeZone.current, from: self)

    guard let hour = component.hour else { return nil }

    return Shichen(dizhi: Dizhi(hourOfDay: hour), date: self)
  }
}
