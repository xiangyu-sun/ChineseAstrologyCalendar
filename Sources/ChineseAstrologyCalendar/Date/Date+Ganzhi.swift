//
//  GanzhiDateConverter.swift
//
//
//  Created by 孙翔宇 on 04/07/2020.
//

import Foundation

// MARK: - GanzhiDateConverter

public extension DateComponents {

  var nian: Ganzhi? {
    guard let t = nianGan else { return nil }
    guard let d = nianZhi else { return nil }

    return Ganzhi(gan: t, zhi: d)
  }

  var yue: Ganzhi? {
    guard let t = yueGan else { return nil }
    guard let d = yueZhi else { return nil }

    return Ganzhi(gan: t, zhi: d)
  }

  var zodiac: Zodiac? {
    if let d = nianZhi {
      let zodiac = Zodiac(d)
      return zodiac
    }
    return nil
  }

}

public extension Date {
   var shichenGTM8: Shichen? {
    let calendar = Calendar.chineseCalendarGTM8

    let component = calendar.dateComponents(in: calendar.timeZone, from: self)

    guard let hour = component.hour else { return nil }

    return Shichen(dizhi: Dizhi(hourOfDay: hour), date: self)
  }

  var shichen: Shichen? {
    let calendar = Calendar.chineseCalendar

    let component = calendar.dateComponents(in: TimeZone.current, from: self)

    guard let hour = component.hour else { return nil }

    return Shichen(dizhi: Dizhi(hourOfDay: hour), date: self)
  }
}
