//
//  File.swift
//  
//
//  Created by Xiangyu Sun on 12/10/22.
//

import Foundation

public enum Season {
    case spring
    case summer
    case fall
    case winter
    
    public var chineseDescription: String {
        switch self {
        case .spring:
            return "春"
        case .summer:
            return "夏"
        case .fall:
            return "秋"
        case .winter:
            return "冬"
        }
    }
    
    public var wuxing: Wuxing {
        switch self {
        case .spring:
            return .mu
        case .summer:
            return .huo
        case .fall:
            return .jin
        case .winter:
            return .shui
        }
    }
    
    public var fangwei: FangWei {
        switch self {
        case .spring:
            return .dong
        case .summer:
            return .nan
        case .fall:
            return .xi
        case .winter:
            return .bei
        }
    }
    
    public var dizhi: [Dizhi] {
        switch self {
        case .spring:
            return [.yin, .mao, .chen]
        case .summer:
            return [.si, .wu, .wei]
        case .fall:
            return [.shen, .chou, .wu]
        case .winter:
            return [.hai, .zi, .chou]
        }
    }
}
