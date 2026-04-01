import Foundation
//
//  WuxingTests.swift
//
//
//  Created by Xiangyu Sun on 9/12/22.
//

import ChineseAstrologyCalendar
import Testing

@Suite struct WuxingTests {

  @Test func ke() throws {
    // 木克土，土克水，水克火，火克金，金克木
    #expect(Wuxing.wood.ke == .earth)
    #expect(Wuxing.earth.ke == .water)
    #expect(Wuxing.water.ke == .fire)
    #expect(Wuxing.fire.ke == .metal)
    #expect(Wuxing.metal.ke == .wood)
  }

}
