//
//  GanzhiDateConverter.swift
//
//
//  Created by 孙翔宇 on 04/07/2020.
//

import Foundation

// MARK: - GanzhiDateConverter

extension Date {
  
  public var nian: Ganzhi? {
    
    guard let t = self.dateComponentsFromChineseCalendar.nianGan else {return nil }
    guard let d = self.dateComponentsFromChineseCalendar.nianZhi else { return nil }

    return Ganzhi(gan: t, zhi: d)
  }

  public var yue: Ganzhi? {
    guard let t = self.dateComponentsFromChineseCalendar.yueGan else { return nil }
    guard let d = self.dateComponentsFromChineseCalendar.yueZhi else { return nil }

    return Ganzhi(gan: t, zhi: d)
  }

  public var zodiac: Zodiac? {
    if let d = self.dateComponentsFromChineseCalendar.nianZhi {
      let zodiac = Zodiac(d)
      return zodiac
    }
    return nil
  }

  public var shichen: Dizhi? {
    let calendar = Calendar.chineseCalendar

    let component = calendar.dateComponents(in: TimeZone.current, from: self)

    guard let hour = component.hour else { return nil }

    return Dizhi(hourOfDay: hour)
  }
  
}
