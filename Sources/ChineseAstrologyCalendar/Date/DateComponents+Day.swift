//  Created by 孙翔宇 on 03/07/2020.
//

import Foundation

extension DateComponents {

  // MARK: Public

  public var riGan: Tiangan? {
    Tiangan(rawValue: base % 10)
  }

  public var riZhi: Dizhi? {
    Dizhi(rawValue: base % 12)
  }

  public var riZhu: Ganzhi? {
    guard let riGan = riGan, let riZhi = riZhi else { return nil }
    return Ganzhi(gan: riGan, zhi: riZhi)
  }

  // MARK: Internal

  var base: Int {
    guard let year = year else {
      return 0
    }
    let x = (year % 100)
    let base = ((x + 7) * 5 + 15 + (x + 19) / 4) % 60

    let jan = DateComponents(year: self.year, month: 1, day: 0)

    let distance = Calendar(identifier: .gregorian).dateComponents([.day, .hour], from: jan, to: self)

    guard let dayDifference = distance.day else {
      return 0
    }
    return (dayDifference + base) % 60
  }
}
