//  Created by 孙翔宇 on 03/07/2020.
//

import Foundation

/// 正月为寅，二月为卯，三月为辰，四月为巳，五月为午，六月为未，七月为申，八月为酉，九月为戌，十月为亥，十一月为子，十二月为丑
extension DateComponents {
  public var yueGan: Tiangan? {
    guard let tiangan = nianGan?.rawValue, let dizhi = yueZhi?.rawValue else { return nil }
    let yueGan = (tiangan * 2 + dizhi) % 10
    if yueGan == 0 {
      return .kui
    }
    return Tiangan(rawValue: yueGan)
  }

  public var yueZhi: Dizhi? {
    guard let month = month, month >= 1 else { return nil }
    return Dizhi.orderedMonthAlCases[month - 1]
  }

  public var yueZhu: Ganzhi? {
    guard let yueGan = yueGan, let yueZhi = yueZhi else { return nil }
    return Ganzhi(gan: yueGan, zhi: yueZhi)
  }
}
