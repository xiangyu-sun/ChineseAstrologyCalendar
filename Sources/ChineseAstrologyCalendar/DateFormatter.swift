//
//  File.swift
//
//
//  Created by Xiangyu Sun on 23/12/22.
//

import Foundation

extension TimeZone {
  static let chinaStandardTime = TimeZone(abbreviation: "GMT+8") ?? .autoupdatingCurrent
}

extension Calendar {

  public static let chineseCalendarGTM8: Calendar = {
    var calendar = Calendar(identifier: .chinese)
    calendar.timeZone = .chinaStandardTime
    return calendar
  }()

  public static var chineseCalendar: Calendar {
    if CalendarManager.shared.useGTM8 {
      return chineseCalendarGTM8

    } else {
      return Calendar(identifier: .chinese)
    }
  }
}

extension DateFormatter {
  public static let chineseENDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.calendar = Calendar.chineseCalendar
    df.dateStyle = .short
    df.locale = Locale(identifier: "en_US")
    return df
  }()

  public static let chineseTranditionalChineseDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.calendar = Calendar.chineseCalendar
    df.dateStyle = .long
    df.locale = Locale(identifier: "zh_Hant")
    return df
  }()

  public static let chineseTranditionalChineseDateFormatterWithGTM8: DateFormatter = {
    let df = DateFormatter()
    df.calendar = Calendar.chineseCalendar
    df.dateStyle = .long
    df.timeZone = .chinaStandardTime
    df.locale = Locale(identifier: "zh_Hant")
    return df
  }()
}
