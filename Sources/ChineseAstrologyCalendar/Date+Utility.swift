//
//  GanzhiDateConverter.swift
//  
//
//  Created by 孙翔宇 on 04/07/2020.
//

import Foundation


public enum DateConvertionError: LocalizedError {
    case dateGanzhiMissing
    case dateComponentsMissing
}

public struct GanzhiDateConverter {
    
    public static func nian(_ date: Date) throws -> Ganzhi {
        guard let t = date.nianGan else { throw DateConvertionError.dateGanzhiMissing}
        guard let d = date.nianZhi else { throw DateConvertionError.dateGanzhiMissing}
        
        return Ganzhi(gan: t, zhi: d)
    }
    
    public static func yue(_ date: Date) throws -> Ganzhi {
        
        guard let t = date.yueGan else { throw DateConvertionError.dateGanzhiMissing}
        guard let d = date.yueZhi else { throw DateConvertionError.dateGanzhiMissing}
        
        return Ganzhi(gan: t, zhi: d)
    }
    
    public static func zodiac(_ date: Date) throws -> Zodiac {
        if let d = date.nianZhi {
            let zodiac = Zodiac(d)
            return zodiac
        }
        
        throw DateConvertionError.dateGanzhiMissing
    }
    
    public static func shichen(_ date: Date) throws -> Dizhi {
        let calendar = Calendar(identifier: .chinese)
        
        let component = calendar.dateComponents(in: TimeZone.current, from: date)
        
        guard let hour = component.hour else { throw DateConvertionError.dateComponentsMissing }
        
        return Dizhi(hourOfDay: hour)
    }
}
