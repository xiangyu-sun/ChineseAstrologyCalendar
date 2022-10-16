//
//  File.swift
//  
//
//  Created by Xiangyu Sun on 12/10/22.
//

import Foundation

public enum Wuxing {
    case jin
    case mu
    case shui
    case huo
    case tu
    
    public var chineseCharacter: String {
        switch self {
        case .jin:
            return "金"
        case .mu:
            return "木"
        case .shui:
            return "水"
        case .huo:
            return "火"
        case .tu:
            return "土"
        }
    }
}
