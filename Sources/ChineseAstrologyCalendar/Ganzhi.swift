//
//  File.swift
//  
//
//  Created by 孙翔宇 on 04/07/2020.
//

import Foundation

public struct Ganzhi: CustomStringConvertible {
    let gan: Tiangan
    let zhi: Dizhi
    
    public var description : String {
        gan.chineseCharactor + zhi.chineseCharactor
    }
}


public extension Ganzhi {
    var formatedYear: String {
        description + "年"
    }
    
    var formatedMonth: String {
        description + "月"
    }
}
