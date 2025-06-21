//  Created by 孙翔宇 on 03/07/2020.
//

import Foundation

extension DateComponents {

  // MARK: Public

  /// 日干：根据 base 计算
  public var riGan: Tiangan? {
    guard let index = cycleIndex else {
      return nil
    }
    let stemIndex = (index - 1) % 10 + 1
    return Tiangan(rawValue: stemIndex)
  }

  /// 日支：根据 base 计算
  public var riZhi: Dizhi? {
    guard let index = cycleIndex else {
      return nil
    }
    let branchIndex = (index - 1) % 12 + 1
    return Dizhi(rawValue: branchIndex)
  }

  /// 日柱：天干与地支的组合
  public var riZhu: Ganzhi? {
    guard let gan = riGan, let zhi = riZhi else { return nil }
    return Ganzhi(gan: gan, zhi: zhi)
  }

  // MARK: Internal

  // MARK: - Internal Computation

  /// Sexagenary cycle index for the day (1...60), where 1 is Jia-Zi.
  private var cycleIndex: Int? {
    let calendar = Calendar(identifier: .gregorian)
    guard
      let date = calendar.date(from: self)
    else {
      return nil
    }
    // Reference date: December 22, 1899 is a Jia-Zi day.
    let referenceComponents = DateComponents(year: 1899, month: 12, day: 22)
    guard let referenceDate = calendar.date(from: referenceComponents) else {
      return nil
    }
    let dayDifference = calendar.dateComponents([.day], from: referenceDate, to: date).day ?? 0
    // Compute cycle index in 1...60
    let index = (dayDifference % 60 + 60) % 60 + 1
    return index
  }
}
