//
//  File.swift
//
//
//  Created by Xiangyu Sun on 23/12/22.
//

import Foundation

extension Calendar {
  public static let chineseCalendar = Calendar(identifier: .chinese)
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
}
