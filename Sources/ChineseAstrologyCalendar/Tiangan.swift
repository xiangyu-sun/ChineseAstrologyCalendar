//
//  Tiangan.swift
//
//
//  Created by 孙翔宇 on 25/03/2020.
//

import Foundation

public enum Tiangan: Int, CaseIterable {
    case jia = 1, yi, bing, ding, wu, ji, geng, xin, ren, kui

    public var displayText: String {
        switch self {
        case .jia:
            return "甲"
        case .yi:
            return "乙"
        case .bing:
            return "丙"
        case .ding:
            return "丁"
        case .wu:
            return "戊"
        case .ji:
            return "己"
        case .geng:
            return "庚"
        case .xin:
            return "辛"
        case .ren:
            return "壬"
        case .kui:
            return "癸"
        }
    }
}

public extension Date {
    var year: String {
        var tianGanDizhi: String?
        if let t = nianGan, let d = nianZhi {
            tianGanDizhi = t.displayText + d.displayText
        }

        if let tianGanDizhi = tianGanDizhi {
            return "\(tianGanDizhi)年"
        }

        return "未卜"
    }

    var month: String {
        var tianGanDizhi: String?
        if let t = yueGan, let d = yueZhi {
            tianGanDizhi = t.displayText + d.displayText
        }

        if let tianGanDizhi = tianGanDizhi {
            return "\(tianGanDizhi)月"
        }

        return "未卜"
    }

    var zodiac: String {
        if let d = nianZhi {
            let zodiac = Zodiac(d)
            return zodiac.rawValue
        }

        return "未卜"
    }

    var shichen: Dizhi? {
        let calendar = Calendar(identifier: .chinese)

        let component = calendar.dateComponents(in: TimeZone.current, from: self)

        guard let hour = component.hour else { return nil }

        return Dizhi(hourOfDay: hour)
    }
}
