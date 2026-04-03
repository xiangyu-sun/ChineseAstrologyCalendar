//
//  DateComponents+Month.swift
//  ChineseAstrologyCalendar
//
//  Created by 孙翔宇 on 03/07/2020.
//  Refined implementation.
//

import Foundation

/// 正月為寅，二月為卯，三月為辰，四月為巳，五月為午，六月為未，七月為申，八月為酉，九月為戌，十月為亥，十一月為子，十二月為丑
extension DateComponents {

  /// 計算月干
  /// 算法：月干 = (年干 × 2 + 月支序數) mod 10
  /// 注意：當結果為 0 時，代表第 10 個天干（癸）
  public var yueGan: Tiangan? {
    // Unwrap the year stem's raw value and the month branch (月支)
    guard
      let yearStemRaw = nianGan?.rawValue,
      let monthZhi = yueZhi
    else {
      return nil
    }

    // 計算月干索引（1～10），把 0 當作 10
    let rawGanIndex = (yearStemRaw * 2 + monthZhi.monthIndex) % 10
    let adjustedGanIndex = (rawGanIndex == 0 ? 10 : rawGanIndex)
    return Tiangan(rawValue: adjustedGanIndex)
  }

  /// 計算月支
  /// 根據公曆的月份，將 1 映射為正月（寅），2 映射為卯，依此類推
  public var yueZhi: Dizhi? {
    // Ensure the month is within the valid range.
    guard
      let month = month,
      month >= 1,
      month <= Dizhi.orderedMonthAlCases.count
    else {
      return nil
    }
    return Dizhi.orderedMonthAlCases[month - 1]
  }

  /// 返回月柱（干支組合）
  public var yueZhu: Ganzhi? {
    guard let gan = yueGan, let zhi = yueZhi else {
      return nil
    }
    return Ganzhi(gan: gan, zhi: zhi)
  }
}
