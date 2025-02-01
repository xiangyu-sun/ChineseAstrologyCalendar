//
//  DateComponents+Month.swift
//  ChineseAstrologyCalendar
//
//  Created by 孙翔宇 on 03/07/2020.
//  Refined implementation.
//

import Foundation

/// 正月为寅，二月为卯，三月为辰，四月为巳，五月为午，六月为未，七月为申，八月为酉，九月为戌，十月为亥，十一月为子，十二月为丑
extension DateComponents {
  
  /// 计算月干
  /// 算法：月干 = (年干 × 2 + 月支序数) mod 10
  /// 注意：当结果为 0 时，代表第 10 个天干（癸）
  public var yueGan: Tiangan? {
    // Unwrap the year stem's raw value and the month branch (月支)
    guard let yearStemRaw = nianGan?.rawValue,
          let monthZhi = yueZhi else {
      return nil
    }
    
    // 计算月干索引（1～10），把 0 当作 10
    let rawGanIndex = (yearStemRaw * 2 + monthZhi.monthIndex) % 10
    let adjustedGanIndex = (rawGanIndex == 0 ? 10 : rawGanIndex)
    return Tiangan(rawValue: adjustedGanIndex)
  }
  
  /// 计算月支
  /// 根据公历的月份，将 1 映射为正月（寅），2 映射为卯，依此类推
  public var yueZhi: Dizhi? {
    // Ensure the month is within the valid range.
    guard let month = month,
          month >= 1,
          month <= Dizhi.orderedMonthAlCases.count else {
      return nil
    }
    return Dizhi.orderedMonthAlCases[month - 1]
  }
  
  /// 返回月柱（干支组合）
  public var yueZhu: Ganzhi? {
    guard let gan = yueGan, let zhi = yueZhi else {
      return nil
    }
    return Ganzhi(gan: gan, zhi: zhi)
  }
}
