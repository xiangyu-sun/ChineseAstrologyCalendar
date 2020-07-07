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
