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
    #expect(Wuxing.mu.ke == .tu)
    #expect(Wuxing.tu.ke == .shui)
    #expect(Wuxing.shui.ke == .huo)
    #expect(Wuxing.huo.ke == .jin)
    #expect(Wuxing.jin.ke == .mu)
  }

}
