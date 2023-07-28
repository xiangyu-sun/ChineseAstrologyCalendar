//
//  File.swift
//
//
//  Created by Xiangyu Sun on 24/12/22.
//

import Foundation

extension DateComponents {
  public static func getDate(year: Int, month: Int, day: Day) -> Date? {
    let adjustedYear = year + 2697
    let chineseEra = Int(adjustedYear / 60)
    let chineseYear = adjustedYear - chineseEra * 60

    let dateComponent = DateComponents(
      calendar: .chineseCalendar,
      era: chineseEra,
      year: chineseYear,
      month: month,
      day: day.rawValue)

    return Calendar.chineseCalendar.date(from: dateComponent)
  }
}
