import Foundation
import Testing
@testable import ChineseAstrologyCalendar

// MARK: - BaziTests

@Suite struct BaziTests {

  // MARK: - Construction

  /// Bazi can be constructed from explicit pillars.
  @Test func baziFromExplicitPillars() {
    // 甲子 乙丑 丙寅 丁卯
    let nian = Ganzhi(gan: .jia, zhi: .zi)
    let yue  = Ganzhi(gan: .yi,  zhi: .chou)
    let ri   = Ganzhi(gan: .bing, zhi: .yin)
    let shi  = Ganzhi(gan: .ding, zhi: .mao)
    let bazi = Bazi(nian: nian, yue: yue, ri: ri, shi: shi)
    #expect(bazi.nian == nian)
    #expect(bazi.yue  == yue)
    #expect(bazi.ri   == ri)
    #expect(bazi.shi  == shi)
  }

  /// Bazi initializes from a Date and returns non-nil.
  @Test func baziFromDateIsNotNil() {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(identifier: "Asia/Shanghai")!
    // Use a known date: Jan 1, 2000, noon CST
    let components = DateComponents(year: 2000, month: 1, day: 1, hour: 12)
    let date = cal.date(from: components)!
    let bazi = Bazi(date: date)
    #expect(bazi != nil)
  }

  /// Bazi from Date produces 4 non-nil pillars.
  @Test func baziFromDateHasFourPillars() {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(identifier: "Asia/Shanghai")!
    let components = DateComponents(year: 2000, month: 1, day: 1, hour: 12)
    let date = cal.date(from: components)!
    guard let bazi = Bazi(date: date) else {
      #expect(Bool(false), "Bazi should not be nil for this date")
      return
    }
    #expect(bazi.pillars.count == 4)
  }

  // MARK: - Day Master

  @Test func dayMasterIsRiGan() {
    let ri = Ganzhi(gan: .jia, zhi: .zi)
    let bazi = Bazi(
      nian: Ganzhi(gan: .geng, zhi: .wu),
      yue:  Ganzhi(gan: .ren, zhi: .shen),
      ri:   ri,
      shi:  Ganzhi(gan: .bing, zhi: .shen)
    )
    #expect(bazi.dayMaster == .jia)
    #expect(bazi.dayMasterElement == .wood)
  }

  // MARK: - Element counts

  @Test func elementCountsSumToEight() {
    let bazi = Bazi(
      nian: Ganzhi(gan: .jia, zhi: .zi),   // mu + shui
      yue:  Ganzhi(gan: .bing, zhi: .yin),  // huo + mu
      ri:   Ganzhi(gan: .wu, zhi: .chen),   // tu + tu
      shi:  Ganzhi(gan: .geng, zhi: .shen)  // jin + jin
    )
    let total = bazi.elementCounts.values.reduce(0, +)
    #expect(total == 8)
  }

  @Test func missingElementsCorrect() {
    // Build a chart with only mu, huo, jin, shui (no tu)
    let bazi = Bazi(
      nian: Ganzhi(gan: .jia, zhi: .yin),   // mu + mu
      yue:  Ganzhi(gan: .bing, zhi: .si),   // huo + huo
      ri:   Ganzhi(gan: .geng, zhi: .shen), // jin + jin
      shi:  Ganzhi(gan: .ren, zhi: .zi)     // shui + shui
    )
    #expect(bazi.missingElements.contains(.earth))
    #expect(!bazi.missingElements.contains(.wood))
    #expect(!bazi.missingElements.contains(.fire))
    #expect(!bazi.missingElements.contains(.metal))
    #expect(!bazi.missingElements.contains(.water))
  }

  // MARK: - Dominant element

  @Test func dominantElementReturnsHighestCount() {
    // Chart with 3 mu and 1 each of huo, tu, jin, shui
    let bazi = Bazi(
      nian: Ganzhi(gan: .jia, zhi: .yin),   // mu + mu
      yue:  Ganzhi(gan: .yi, zhi: .mao),    // mu + mu
      ri:   Ganzhi(gan: .bing, zhi: .si),   // huo + huo
      shi:  Ganzhi(gan: .wu, zhi: .zi)      // tu + shui
    )
    // mu appears 4 times (jia=mu, yin=mu, yi=mu, mao=mu)
    #expect(bazi.dominantElement == .wood)
  }

  // MARK: - Beneficial element

  @Test func beneficialElementGeneratesDayMaster() {
    // Day master 甲 (jia, mu) — beneficial element is shui (水生木)
    let bazi = Bazi(
      nian: Ganzhi(gan: .geng, zhi: .wu),
      yue:  Ganzhi(gan: .ren,  zhi: .shen),
      ri:   Ganzhi(gan: .jia,  zhi: .zi),
      shi:  Ganzhi(gan: .bing, zhi: .shen)
    )
    // Water (shui) generates Wood (mu)
    #expect(bazi.beneficialElement.sheng == .wood)
    #expect(bazi.beneficialElement == .water)
  }

  // MARK: - Description

  @Test func descriptionHasFourPillars() {
    let bazi = Bazi(
      nian: Ganzhi(gan: .jia, zhi: .zi),
      yue:  Ganzhi(gan: .yi,  zhi: .chou),
      ri:   Ganzhi(gan: .bing, zhi: .yin),
      shi:  Ganzhi(gan: .ding, zhi: .mao)
    )
    // "甲子 乙丑 丙寅 丁卯"
    let parts = bazi.description.split(separator: " ")
    #expect(parts.count == 4)
  }

  @Test func allCharactersHasEightElements() {
    let bazi = Bazi(
      nian: Ganzhi(gan: .jia,  zhi: .zi),
      yue:  Ganzhi(gan: .yi,   zhi: .chou),
      ri:   Ganzhi(gan: .bing, zhi: .yin),
      shi:  Ganzhi(gan: .ding, zhi: .mao)
    )
    #expect(bazi.allCharacters.count == 8)
  }
}
