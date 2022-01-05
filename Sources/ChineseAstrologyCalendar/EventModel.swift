import Foundation

public struct EventModel: Codable {
    public init(date: Date, name: Day, dateComponents: DateComponents) {
        self.date = date
        self.day = name
        self.dateComponents = dateComponents
    }
    
    public let date: Date
    public let dateComponents: DateComponents
    public let day: Day
    
}

extension EventModel {
    private static var enToChNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = tranditonalChineseLocal
        formatter.numberStyle = .spellOut
        return formatter
    }
    
    var title: String {
        let month = NSNumber(value: dateComponents.month ?? 1)
        return "\(String(describing: EventModel.enToChNumberFormatter.string(from: month))) \(day.name)"
    }
}
