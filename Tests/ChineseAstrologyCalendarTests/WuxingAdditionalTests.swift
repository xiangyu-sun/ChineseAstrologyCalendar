import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct WuxingAdditionalTests {

  @Test func shengCycle() {
    #expect(Wuxing.mu.sheng == .huo)
    #expect(Wuxing.huo.sheng == .tu)
    #expect(Wuxing.tu.sheng == .jin)
    #expect(Wuxing.jin.sheng == .shui)
    #expect(Wuxing.shui.sheng == .mu)
  }

  @Test func colorsAndFlavors() {
    #expect(Wuxing.mu.colorDescription == "青")
    #expect(Wuxing.jin.colorDescription == "白")
    #expect(Wuxing.huo.fiveFlavor == "苦")
  }

  @Test func fangWei() {
    #expect(Wuxing.mu.fangwei == .dong)
    #expect(Wuxing.tu.fangwei == .zhong)
  }
}
