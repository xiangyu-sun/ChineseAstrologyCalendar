import Testing
@testable import ChineseAstrologyCalendar

@Suite struct SeasonTests {

  @Test func wuxingMapping() {
    #expect(Season.spring.wuxing == .mu)
    #expect(Season.summer.wuxing == .huo)
    #expect(Season.fall.wuxing == .jin)
    #expect(Season.winter.wuxing == .shui)
  }

  @Test func dizhiBranches() {
    // Spring: Wood (木) — 寅、卯、辰
    #expect(Season.spring.dizhi == [.yin, .mao, .chen])
    // Summer: Fire (火) — 巳、午、未
    #expect(Season.summer.dizhi == [.si, .wu, .wei])
    // Fall: Metal (金) — 申、酉、戌
    #expect(Season.fall.dizhi == [.shen, .you, .xu])
    // Winter: Water (水) — 亥、子、丑
    #expect(Season.winter.dizhi == [.hai, .zi, .chou])
  }

  @Test func dizhiWuxingConsistency() {
    // Each season's branches should map to the same Wuxing as the season itself
    // (excluding the Earth transitional branches chen/wei/xu/chou)
    let springMainBranches = Season.spring.dizhi.filter { $0.wuxing == .mu }
    #expect(springMainBranches == [.yin, .mao])

    let summerMainBranches = Season.summer.dizhi.filter { $0.wuxing == .huo }
    #expect(summerMainBranches == [.si, .wu])

    let fallMainBranches = Season.fall.dizhi.filter { $0.wuxing == .jin }
    #expect(fallMainBranches == [.shen, .you])

    let winterMainBranches = Season.winter.dizhi.filter { $0.wuxing == .shui }
    #expect(winterMainBranches == [.hai, .zi])
  }

  @Test func fangweiMapping() {
    #expect(Season.spring.fangwei == .dong)
    #expect(Season.summer.fangwei == .nan)
    #expect(Season.fall.fangwei == .xi)
    #expect(Season.winter.fangwei == .bei)
  }

  @Test func chineseDescriptions() {
    #expect(Season.spring.chineseDescription == "春")
    #expect(Season.summer.chineseDescription == "夏")
    #expect(Season.fall.chineseDescription == "秋")
    #expect(Season.winter.chineseDescription == "冬")
  }

  @Test func allCasesCount() {
    #expect(Season.allCases.count == 4)
  }
}
