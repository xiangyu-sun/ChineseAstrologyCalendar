import Foundation

public final class DayConverter {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public func find(days: [Day], inNextMonths: Int, from date: Date = Date()) -> [EventModel] {
    let compoents = Calendar.chineseCalendar.dateComponents([.era,.year,.month,.day], from: date)

    return Array(0..<inNextMonths).reduce(into: [EventModel]()) { result, month in

      for d in days {
        var copy = compoents

        let newMonth = (copy.month! + month)
        let newYear: Float = (Float(newMonth) / 13.0).rounded(.towardZero)

        copy.month = newMonth <= 12 ? newMonth : newMonth - 12
        copy.year! += Int(newYear)
        copy.day = d.rawValue

        guard let date = Calendar.chineseCalendar.date(from: copy), isValid(component: copy, date: date) else {
          continue
        }

        result.append(EventModel(date: date, name: d, dateComponents: copy))
      }
    }
  }

  public func find(day: Day, month: Dizhi , inNextYears: Int, from date: Date = Date()) -> [EventModel] {
    let compoents = Calendar.chineseCalendar.dateComponents([.era,.year,.month,.day], from: date)

    return Array(0..<inNextYears).reduce(into: [EventModel]()) { result, year in

      var copy = compoents
      copy.month = month.rawValue
      copy.year! += Int(year)
      copy.day = day.rawValue

      guard let date = Calendar.chineseCalendar.date(from: copy), isValid(component: copy, date: date) else {
        return
      }

      result.append(EventModel(date: date, name: day, dateComponents: copy))
    }
  }

  // MARK: Internal

  func isValid(component: DateComponents, date: Date) -> Bool {
    date >= Date() &&
      Calendar.chineseCalendar.dateComponents([.era,.year,.month,.day], from: date) == component
  }

}
