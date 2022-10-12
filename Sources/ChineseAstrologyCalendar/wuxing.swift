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
    
    
    public var dizhi: [Dizhi] {
        switch self {
        case .jin:
            return [.yin, .mao]
        case .mu:
            return [.si, .wu]
        case .shui:
            return [.shen, .chou, .wu]
        case .huo:
            return [.hai, .zi, .chou]
        case .tu:
            return [.chen, .wei, .wu, .chou]
        }
    }
}
