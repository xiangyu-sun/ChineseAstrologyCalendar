//  Created by 孙翔宇 on 03/07/2020.
//  Copyright © 2020 孙翔宇. All rights reserved.
//

import Foundation

extension Date {
  public var chineseDate: String {
    let dateInChinese = DateFormatter.chineseTranditionalChineseDateFormatter.string(from: self)
    guard let index = dateInChinese.firstIndex(of: "月") else { return "" }
    let start = index.utf16Offset(in: dateInChinese) + 1

    return String(dateInChinese[.init(utf16Offset: start, in: dateInChinese)...])
  }

  public var chineseYearMonthDate: String {
    let dateInChinese = DateFormatter.chineseTranditionalChineseDateFormatter.string(from: self)

    return String(dateInChinese[String.Index(utf16Offset: 4, in: dateInChinese)..<dateInChinese.endIndex])
  }

  public var displayStringOfChineseYearMonthDateWithZodiac: String {
    var result = chineseYearMonthDate

    let dateCompoenent = dateComponentsFromChineseCalendar()

    guard let index = result.firstIndex(of: "年") else { return "" }

    guard let zodiac = (dateCompoenent.zodiac?.rawValue ?? "").first else { return "" }

    result.insert(zodiac, at: index)

    return result
  }

  public var chineseDateGTM8: String {
    let dateInChinese = DateFormatter.chineseTranditionalChineseDateFormatterWithGTM8.string(from: self)
    guard let index = dateInChinese.firstIndex(of: "月") else { return "" }
    let start = index.utf16Offset(in: dateInChinese) + 1

    return String(dateInChinese[.init(utf16Offset: start, in: dateInChinese)...])
  }

  public var chineseYearMonthDateGTM8: String {
    let dateInChinese = DateFormatter.chineseTranditionalChineseDateFormatterWithGTM8.string(from: self)

    return String(dateInChinese[String.Index(utf16Offset: 4, in: dateInChinese)..<dateInChinese.endIndex])
  }

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
  var nianGan: Tiangan? {
    var t = chineseYear % 10
    if t == 0 {
      t = 10
    }
    return Tiangan(rawValue: t)
  }

  var nianZhi: Dizhi? {
    let t = chineseYear % 12
    return Dizhi.allCases[t - 1]
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
