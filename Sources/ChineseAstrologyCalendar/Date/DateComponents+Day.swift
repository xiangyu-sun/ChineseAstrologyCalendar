//  Created by 孙翔宇 on 03/07/2020.
//

import Foundation

import Foundation

extension DateComponents {

  // MARK: - Public

  /// 日干：根据 base 计算
  public var riGan: Tiangan? {
    guard let base else {
      return nil
    }
    // Compute the heavenly stem from the base value.
    // Depending on your Tiangan enum, you might need to remap a 0 value to 10.
    let index = base % 10 == 0 ? 10 : base % 10
    return Tiangan(rawValue: index)
  }

  /// 日支：根据 base 计算
  public var riZhi: Dizhi? {
    guard let base else {
      return nil
    }
    // Compute the earthly branch from the base value.
    // As above, adjust for a 0 result if your Dizhi enum requires 1...12.
    let index = base % 12 == 0 ? 12 : base % 12
    return Dizhi(rawValue: index)
  }

  /// 日柱：天干与地支的组合
  public var riZhu: Ganzhi? {
    guard let gan = riGan, let zhi = riZhi else { return nil }
    return Ganzhi(gan: gan, zhi: zhi)
  }

  // MARK: - Internal Computation

  /// Computes a base value used for determining the day stem and branch.
  /// - Note: The algorithm works as follows:
  ///   1. Take the last two digits of the year (`yearInCentury`).
  ///   2. Compute an intermediate value using the formula:
  ///      `((yearInCentury + 7) * 5 + 15 + (yearInCentury + 19) / 4) % 60`
  ///   3. Use January 1 of the current year as a baseline and add the day difference.
  ///   4. Return the sum modulo 60.
  var base: Int? {
    guard let year = year else {
      return nil
    }
    
    // 1. Compute the last two digits of the year.
    let yearInCentury = year % 100
    
    // 2. Compute the intermediate base value.
    let baseValue = ((yearInCentury + 7) * 5 + 15 + (yearInCentury + 19) / 4) % 60
    
    // 3. Use January 1 as the baseline date.
    let januaryFirst = DateComponents(year: year, month: 1, day: 1)
    let calendar = Calendar(identifier: .gregorian)
    
    // Convert DateComponents to Date.
    guard let startDate = calendar.date(from: januaryFirst),
          let currentDate = calendar.date(from: self) else {
      return baseValue
    }
    
    // Compute the day difference between January 1 and the current date.
    let dayDifference = calendar.dateComponents([.day], from: startDate, to: currentDate).day ?? 0
    
    // 4. Return the adjusted base value modulo 60.
    return (baseValue + dayDifference) % 60
  }
}
