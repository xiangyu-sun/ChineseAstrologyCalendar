import Foundation

public final class DayConverter {

  let calendar: Calendar
  
  // MARK: Lifecycle

  public init(calendar: Calendar = .chineseCalendar) {
    self.calendar = calendar
  }

  // MARK: Public

  public func find(days: [Day], inNextMonths: Int, from date: Date = Date()) -> [EventModel] {
    let components = calendar.dateComponents([.era,.year,.month,.day], from: date)

    return Array(0..<inNextMonths).reduce(into: [EventModel]()) { result, month in

      for d in days {
        var copy = components

        let newMonth = (copy.month! + month)
        let newYear: Float = (Float(newMonth) / 13.0).rounded(.towardZero)

        copy.month = newMonth <= 12 ? newMonth : newMonth - 12
        copy.year! += Int(newYear)
        copy.day = d.rawValue

        guard
          let targetDate = calendar.date(from: copy),
          isValid(component: copy, targetDate: targetDate, originDate: date) else
        {
          continue
        }

        result.append(EventModel(date: targetDate, name: d, dateComponents: copy))
      }
    }
  }

  public func find(day: Day, month: Dizhi , inNextYears: Int, from date: Date = Date()) -> [EventModel] {
    let compoents = calendar.dateComponents([.era,.year,.month,.day], from: date)
    let monthConverted = (Dizhi.orderedMonthAlCases.firstIndex(of: month) ?? 0) + 1
    return Array(0...inNextYears).reduce(into: [EventModel]()) { result, year in

      var copy = compoents
      copy.month = monthConverted
      copy.year! += Int(year)
      copy.day = day.rawValue

      guard
        let targetDate = calendar.date(from: copy),
        isValid(component: copy, targetDate: targetDate, originDate: date) else
      {
        return
      }

      result.append(EventModel(date: targetDate, name: day, dateComponents: copy))
    }
  }

  // MARK: Internal

  func isValid(component: DateComponents, targetDate: Date, originDate: Date) -> Bool {
    targetDate >= originDate && calendar
      .dateComponents([.era,.year,.month,.day], from: targetDate) == component
  }

}
