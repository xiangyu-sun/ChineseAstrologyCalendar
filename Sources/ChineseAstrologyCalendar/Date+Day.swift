import Foundation

public final class DayConverter {
    
    let calendar = Calendar(identifier: .chinese)
    
    public init() {}
    
    public func find(days: Array<Day>, inNextMonths: Int, from date: Date = Date()) -> [EventModel] {
        let compoents = calendar.dateComponents([.era,.year,.month,.day], from: date)
        
        return Array(0..<inNextMonths).reduce(into: [EventModel]()){result, month in
            
            for d in days {
                var copy = compoents
                
                let newMonth = (copy.month! + month)
                let newYear: Float = (Float(newMonth) / 13.0).rounded(.towardZero)
                
                copy.month = newMonth <= 12 ? newMonth : newMonth - 12
                copy.year! += Int(newYear)
                copy.day = d.rawValue
                
                guard let date = calendar.date(from: copy), isValid(component: copy, date: date) else {
                    continue
                }
                
                result.append(EventModel(date: date, name: d, dateComponents: copy))
            }
        }
    }
    
    func isValid(component: DateComponents, date: Date) -> Bool{
        date >= Date() &&
        calendar.dateComponents([.era,.year,.month,.day], from: date) == component
    }
    
}
