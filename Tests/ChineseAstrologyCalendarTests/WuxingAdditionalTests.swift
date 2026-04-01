import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct WuxingAdditionalTests {

  @Test func shengCycle() {
    #expect(Wuxing.wood.sheng == .fire)
    #expect(Wuxing.fire.sheng == .earth)
    #expect(Wuxing.earth.sheng == .metal)
    #expect(Wuxing.metal.sheng == .water)
    #expect(Wuxing.water.sheng == .wood)
  }

  @Test func colorsAndFlavors() {
    #expect(Wuxing.wood.colorDescription == "青")
    #expect(Wuxing.metal.colorDescription == "白")
    #expect(Wuxing.fire.fiveFlavor == "苦")
  }

  @Test func fangWei() {
    #expect(Wuxing.wood.fangwei == .east)
    #expect(Wuxing.earth.fangwei == .center)
  }
}
