//
//  Zodiac.swift
//  
//
//  Created by 孙翔宇 on 25/03/2020.
//

import Foundation

public protocol DizhiConvertible {
    init(_ dizhi: Dizhi)
}

public enum Zodiac: String, DizhiConvertible{
    public init(_ dizhi: Dizhi) {
        switch dizhi {
        case .zi:
            self = .鼠
        case .chou:
            self = .牛
        case .yin:
            self = .虎
        case .mao:
            self = .兔
        case .chen:
            self = .龙
        case .si:
            self = .蛇
        case .wu:
            self = .马
        case .wei:
            self = .羊
        case .shen:
            self = .猴
        case .you:
            self = .鸡
        case .xu:
            self = .狗
        case .hai:
            self = .猪
        }
    }
    
    case 鼠, 牛, 虎, 兔, 龙, 蛇, 马, 羊, 猴, 鸡, 狗, 猪
}
