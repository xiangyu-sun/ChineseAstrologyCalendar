//
//  File.swift
//
//
//  Created by Xiangyu Sun on 23/12/22.
//

import Foundation

public struct Shichen: Codable {

  public let dizhi: Dizhi
  public let date: Date
  public var ke: Double { 15 * 60 }
  
  public var currentKe: Int {
    Int((date.timeIntervalSince1970 - startDate.timeIntervalSince1970) / ke)
  }
  
  public init(dizhi: Dizhi, date: Date) {
    self.dizhi = dizhi
    self.date = date
  }

  public var startDate: Date {
    let startHour = dizhi.hourInterval.start

    var startDP = Calendar.current.dateComponents(
      [.year, .month, .day,.hour, .minute, .second, .nanosecond],
      from: date)

    if startHour == 23, startDP.hour == 0 {
      startDP.day = startDP.day! - 1
    }

    startDP.hour = startHour
    startDP.minute = 0
    startDP.second = 0
    startDP.nanosecond = 0

    return Calendar.current.date(from: startDP) ?? Date()
  }

  public var endDate: Date {
    let endHour = dizhi.hourInterval.end

    var endDP = Calendar.current.dateComponents([.year, .month, .day,.hour, .minute, .second, .nanosecond], from: date)

    if endHour == 0, endDP.hour == 23 {
      endDP.day = endDP.day! + 1
    }

    endDP.hour = endHour
    endDP.minute = 59
    endDP.second = 59

    return Calendar.current.date(from: endDP) ?? Date()
  }

  public var nextStartDate: Date {
    let startHour = dizhi.next.hourInterval.start

    var startDP = Calendar.current.dateComponents(
      [.year, .month, .day,.hour, .minute, .second, .nanosecond],
      from: date)

    if startHour == 23, startDP.hour == 0 {
      startDP.day = startDP.day! - 1
    }

    startDP.hour = startHour
    startDP.minute = 0
    startDP.second = 0
    startDP.nanosecond = 0

    return Calendar.current.date(from: startDP) ?? Date()
  }
}
