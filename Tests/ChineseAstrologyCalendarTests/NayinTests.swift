import Testing
@testable import ChineseAstrologyCalendar

// MARK: - NayinTests

@Suite struct NayinTests {

  // MARK: - Known Nayin mappings

  /// The first pair in the 60-cycle (甲子/乙丑) maps to 海中金.
  @Test func jiaziFistPairIsHaiZhongJin() {
    let jiaZi = Ganzhi(gan: .jia, zhi: .zi)
    let yiChou = Ganzhi(gan: .yi, zhi: .chou)
    #expect(jiaZi.nayin == .seaGold)
    #expect(yiChou.nayin == .seaGold)
  }

  /// The second pair (丙寅/丁卯) maps to 炉中火.
  @Test func secondPairIsLuZhongHuo() {
    let bingYin = Ganzhi(gan: .bing, zhi: .yin)
    let dingMao = Ganzhi(gan: .ding, zhi: .mao)
    #expect(bingYin.nayin == .furnaceFire)
    #expect(dingMao.nayin == .furnaceFire)
  }

  /// Third pair (戊辰/己巳) maps to 大林木.
  @Test func thirdPairIsDaLinMu() {
    let wuChen = Ganzhi(gan: .wu, zhi: .chen)
    let jiSi = Ganzhi(gan: .ji, zhi: .si)
    #expect(wuChen.nayin == .forestWood)
    #expect(jiSi.nayin == .forestWood)
  }

  /// Fourth pair (庚午/辛未) maps to 路旁土.
  @Test func fourthPairIsLuPangTu() {
    let gengWu = Ganzhi(gan: .geng, zhi: .wu)
    let xinWei = Ganzhi(gan: .xin, zhi: .wei)
    #expect(gengWu.nayin == .roadsideEarth)
    #expect(xinWei.nayin == .roadsideEarth)
  }

  /// Last pair in the cycle (壬戌/癸亥) maps to 大海水.
  @Test func lastPairIsDaHaiShui() {
    let renXu = Ganzhi(gan: .ren, zhi: .xu)
    let kuiHai = Ganzhi(gan: .kui, zhi: .hai)
    #expect(renXu.nayin == .oceanWater)
    #expect(kuiHai.nayin == .oceanWater)
  }

  // MARK: - Wuxing element of Nayin

  @Test func nayinWuxingMapping() {
    #expect(Nayin.seaGold.wuxing == .metal)
    #expect(Nayin.furnaceFire.wuxing == .fire)
    #expect(Nayin.forestWood.wuxing == .wood)
    #expect(Nayin.roadsideEarth.wuxing == .earth)
    #expect(Nayin.ravineWater.wuxing == .water)
  }

  /// All 30 Nayin cases cover 5 elements, 6 each.
  @Test func nayinCoversAllElementsEqually() {
    let all = Nayin.allCases
    #expect(all.count == 30)
    for element in Wuxing.allCases {
      let count = all.filter { $0.wuxing == element }.count
      #expect(count == 6, "\(element.chineseCharacter) should appear 6 times in Nayin, got \(count)")
    }
  }

  // MARK: - Consecutive pairs share Nayin

  @Test func consecutivePairsShareNayin() {
    let all = getJiazhi()
    #expect(all.count == 60)
    for i in stride(from: 0, to: 60, by: 2) {
      #expect(all[i].nayin == all[i + 1].nayin,
              "Pair at \(i) should share Nayin: \(all[i]) \(all[i+1])")
    }
  }

  /// Adjacent pairs (different pairs) have different Nayin.
  @Test func adjacentPairsHaveDifferentNayin() {
    let all = getJiazhi()
    for i in stride(from: 0, to: 58, by: 2) {
      #expect(all[i].nayin != all[i + 2].nayin,
              "Different pairs should have different Nayin")
    }
  }
}
