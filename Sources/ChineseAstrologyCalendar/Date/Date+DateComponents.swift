//
//  File.swift
//
//
//  Created by Xiangyu Sun on 23/12/22.
//

import Foundation

extension Date {
  /// .era,.year,.month,.day,.hour,.minute,.second, .nanosecond
  public var dateComponentsFromCurrentCalendar: DateComponents {
    Calendar.current.dateComponents([.era,.year,.month,.day,.hour,.minute,.second, .nanosecond], from: self)
  }

  // Chinese calendar date components
  public func dateComponentsFromChineseCalendar(_ calendar: Calendar = .chineseCalendar) -> DateComponents {
    let elements = DateFormatter.chineseENDateFormatter.string(from: self).split(separator: "/")
    let day = Int(elements[1])
    let month = Int(elements[0])
    let year = Int(elements[2])

    let orginalDateComponents = dateComponentsFromCurrentCalendar

    var dp = DateComponents(calendar: calendar)
    dp.day = day
    dp.month = month
    dp.era = orginalDateComponents.chineseEra
    dp.year = year
    dp.hour = orginalDateComponents.hour
    dp.minute = orginalDateComponents.minute
    dp.second = orginalDateComponents.second
    dp.nanosecond = orginalDateComponents.nanosecond

    return dp
  }

}
