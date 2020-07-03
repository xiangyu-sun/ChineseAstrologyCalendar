//
//  Dizhi.swift
//
//
//  Created by 孙翔宇 on 25/03/2020.
//

import Foundation

public protocol TimeExpressible {
    init(hourOfDay: Int)
    var displayText: String { get }
    var displayHourText: String { get }
    var displayHourDetailText: String { get }
}

public protocol MonthExpressible {
    var displayMonthText: String { get }
}

public enum Dizhi: Int, CaseIterable {
    case yin = 1, mao, chen, si, wu, wei, shen, you, xu, hai, zi, chou

    public var displayText: String {
        switch self {
        case .zi:
            return "子"
        case .chou:
            return "丑"
        case .yin:
            return "寅"
        case .mao:
            return "卯"
        case .chen:
            return "辰"
        case .si:
            return "巳"
        case .wu:
            return "午"
        case .wei:
            return "未"
        case .shen:
            return "申"
        case .you:
            return "酉"
        case .xu:
            return "戌"
        case .hai:
            return "亥"
        }
    }
}

public struct HourInterval<T> where T: Comparable {
    let start: T
    let end: T
}

extension HourInterval: CustomStringConvertible where T == Int {
    public var description: String {
        "From \(start) to \(end)"
        // String.localizedStringWithFormat("From %@ to %@", start, end)
    }
}

extension Dizhi: TimeExpressible {
    public init(hourOfDay: Int) {
        switch hourOfDay {
        case 23, 0:
            self = .zi
        case 1, 2:
            self = .chou
        case 3, 4:
            self = .yin
        case 5, 6:
            self = .mao
        case 7, 8:
            self = .chen
        case 9, 10:
            self = .si
        case 11, 12:
            self = .wu
        case 13, 14:
            self = .wei
        case 15, 16:
            self = .shen
        case 17, 18:
            self = .you
        case 19, 20:
            self = .xu
        case 21, 22:
            self = .hai
        default:
            self = .zi
        }
    }

    public var hourInterval: HourInterval<Int> {
        switch self {
        case .zi:
            return .init(start: 23, end: 0)
        case .chou:
            return .init(start: 1, end: 2)
        case .yin:
            return .init(start: 3, end: 4)
        case .mao:
            return .init(start: 5, end: 6)
        case .chen:
            return .init(start: 7, end: 8)
        case .si:
            return .init(start: 9, end: 10)
        case .wu:
            return .init(start: 11, end: 12)
        case .wei:
            return .init(start: 13, end: 14)
        case .shen:
            return .init(start: 15, end: 16)
        case .you:
            return .init(start: 17, end: 18)
        case .xu:
            return .init(start: 19, end: 20)
        case .hai:
            return .init(start: 21, end: 22)
        }
    }

    public var displayHourText: String { displayText + "時" }

    public var displayHourDetailText: String { "\(displayText) \(hourInterval.description) 時" }
}
