//
//  File.swift
//
//
//  Created by Xiangyu Sun on 23/1/23.
//

import Foundation

extension DateComponents {
  public var shiGan: Tiangan? {
    guard let riGan = riGan, let riZhi = riZhi else {
      return nil
    }
    let base = (riGan.rawValue * 2) + riZhi.rawValue - 2
    return Tiangan(rawValue: base % 10)
  }

  public var shiZhi: Dizhi {
    Dizhi(hourOfDay: hour ?? 0)
  }

  public var shiZhu: Ganzhi? {
    guard let shiGan = shiGan else { return nil }
    return Ganzhi(gan: shiGan, zhi: shiZhi)
  }

}
