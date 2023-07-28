//
//  File.swift
//
//
//  Created by Xiangyu Sun on 23/12/22.
//

import Foundation

extension Date {

  public func chineseDay(calendar: Calendar = .chineseCalendar) -> Day? {
    guard let day = dateComponentsFromChineseCalendar(calendar).day else { return nil }
    return Day(rawValue: day)
  }

}
