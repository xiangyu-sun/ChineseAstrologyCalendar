//  Created by 孙翔宇 on 03/07/2020.
//  Copyright © 2020 孙翔宇. All rights reserved.
//

import Foundation

public extension Date {
    static let chineseDF: DateFormatter = {
       let df =  DateFormatter()
        df.calendar = Date.chineseCalendar
        df.dateStyle = .short
        return df
    }()
    
    static let chineseCalendar = Calendar(identifier: .chinese)
    
    var dateComponentsFromCurrentCalendar: DateComponents {
        Calendar.current.dateComponents([.era,.year,.month,.day,.hour,.minute,.second], from: self)
    }
    
    var dateComponentsFromChineseCalendar: DateComponents {
        let elements = Date.chineseDF.string(from: self).split(separator: "/")
        let day = Int(elements[1])
        let month = Int(elements[0])
        let year = Int(elements[2])
        
        let orginalDateComponents = self.dateComponentsFromCurrentCalendar
        
        var dp = DateComponents(calendar: Date.chineseCalendar)
        dp.day = day
        dp.month = month
        dp.era = orginalDateComponents.chineseEra
        dp.year = year
        dp.hour = orginalDateComponents.hour
        dp.minute = orginalDateComponents.minute
        dp.second = orginalDateComponents.second
        
        return dp
    }
    
}

extension DateComponents {
    var nianGan: Tiangan? {
        let t = chineseYear % 10
        return Tiangan(rawValue: t)
    }

    var nianZhi: Dizhi? {
        let t = chineseYear % 12
        return Dizhi.orderedAllCases[t-1]
    }
    
    var chineseYear: Int {
        let g_adj_year =  (year ?? 0) + 2697

        let c_era = Int(g_adj_year/60)
        return  g_adj_year - c_era * 60
    }
    
    var chineseEra: Int {
        let g_adj_year = (year ?? 0) + 2697
        return Int(g_adj_year/60)
    }
}
