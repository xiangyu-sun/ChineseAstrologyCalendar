//
//  File.swift
//
//
//  Created by Xiangyu Sun on 23/12/22.
//

import Foundation

extension Date {

  public var chineseDay: Day? {
    guard let day = dateComponentsFromChineseCalendar.day else { return nil }
    return Day(rawValue: day)
  }

}
