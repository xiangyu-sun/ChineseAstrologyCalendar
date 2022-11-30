//  Created by 孙翔宇 on 03/07/2020.
//  Copyright © 2020 孙翔宇. All rights reserved.
//

import Foundation

extension Calendar {
  static let chineseCalendar = Calendar(identifier: .chinese)
}

extension Date {
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

  public var dateComponentsFromCurrentCalendar: DateComponents {
    Calendar.current.dateComponents([.era,.year,.month,.day,.hour,.minute,.second], from: self)
  }

  public var dateComponentsFromChineseCalendar: DateComponents {
    let elements = Date.chineseENDateFormatter.string(from: self).split(separator: "/")
    let day = Int(elements[1])
    let month = Int(elements[0])
    let year = Int(elements[2])

    let orginalDateComponents = dateComponentsFromCurrentCalendar

    var dp = DateComponents(calendar: Calendar.chineseCalendar)
    dp.day = day
    dp.month = month
    dp.era = orginalDateComponents.chineseEra
    dp.year = year
    dp.hour = orginalDateComponents.hour
    dp.minute = orginalDateComponents.minute
    dp.second = orginalDateComponents.second

    return dp
  }

  public var chineseDate: String {
    let dateInChinese = Date.chineseTranditionalChineseDateFormatter.string(from: self)
    guard let index = dateInChinese.firstIndex(of: "月") else { return "" }
    let start = index.utf16Offset(in: dateInChinese) + 1

    return String(dateInChinese[.init(utf16Offset: start, in: dateInChinese)...])
  }

  public var chineseYearMonthDate: String {
    let dateInChinese = Date.chineseTranditionalChineseDateFormatter.string(from: self)

    return String(dateInChinese[String.Index(utf16Offset: 4, in: dateInChinese)..<dateInChinese.endIndex])
  }

  public var displayStringOfChineseYearMonthDateWithZodiac: String {
    var result = chineseYearMonthDate

    guard let index = result.firstIndex(of: "年") else { return "" }

    guard let zodiac = ((try? GanzhiDateConverter.zodiac(self).rawValue) ?? "").first else { return "" }

    result.insert(zodiac, at: index)

    return result
  }
}

extension DateComponents {
  var nianGan: Tiangan? {
    let t = chineseYear % 10
    return Tiangan(rawValue: t)
  }

  var nianZhi: Dizhi? {
    let t = chineseYear % 12
    return Dizhi.orderedAllCases[t - 1]
  }

  var chineseYear: Int {
    let g_adj_year = (year ?? 0) + 2697

    let c_era = Int(g_adj_year / 60)
    return g_adj_year - c_era * 60
  }

  var chineseEra: Int {
    let g_adj_year = (year ?? 0) + 2697
    return Int(g_adj_year / 60)
  }
}
