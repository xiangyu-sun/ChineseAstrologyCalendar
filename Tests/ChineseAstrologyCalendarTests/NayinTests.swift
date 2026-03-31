import Testing
@testable import ChineseAstrologyCalendar

// MARK: - NayinTests

@Suite struct NayinTests {

  // MARK: - Known Nayin mappings

  /// The first pair in the 60-cycle (甲子/乙丑) maps to 海中金.
  @Test func jiaziFistPairIsHaiZhongJin() {
    let jiaZi = Ganzhi(gan: .jia, zhi: .zi)
    let yiChou = Ganzhi(gan: .yi, zhi: .chou)
    #expect(jiaZi.nayin == .海中金)
    #expect(yiChou.nayin == .海中金)
  }

  /// The second pair (丙寅/丁卯) maps to 炉中火.
  @Test func secondPairIsLuZhongHuo() {
    let bingYin = Ganzhi(gan: .bing, zhi: .yin)
    let dingMao = Ganzhi(gan: .ding, zhi: .mao)
    #expect(bingYin.nayin == .炉中火)
    #expect(dingMao.nayin == .炉中火)
  }

  /// Third pair (戊辰/己巳) maps to 大林木.
  @Test func thirdPairIsDaLinMu() {
    let wuChen = Ganzhi(gan: .wu, zhi: .chen)
    let jiSi = Ganzhi(gan: .ji, zhi: .si)
    #expect(wuChen.nayin == .大林木)
    #expect(jiSi.nayin == .大林木)
  }

  /// Fourth pair (庚午/辛未) maps to 路旁土.
  @Test func fourthPairIsLuPangTu() {
    let gengWu = Ganzhi(gan: .geng, zhi: .wu)
    let xinWei = Ganzhi(gan: .xin, zhi: .wei)
    #expect(gengWu.nayin == .路旁土)
    #expect(xinWei.nayin == .路旁土)
  }

  /// Last pair in the cycle (壬戌/癸亥) maps to 大海水.
  @Test func lastPairIsDaHaiShui() {
    let renXu = Ganzhi(gan: .ren, zhi: .xu)
    let kuiHai = Ganzhi(gan: .kui, zhi: .hai)
    #expect(renXu.nayin == .大海水)
    #expect(kuiHai.nayin == .大海水)
  }

  // MARK: - Wuxing element of Nayin

  @Test func nayinWuxingMapping() {
    #expect(Nayin.海中金.wuxing == .jin)
    #expect(Nayin.炉中火.wuxing == .huo)
    #expect(Nayin.大林木.wuxing == .mu)
    #expect(Nayin.路旁土.wuxing == .tu)
    #expect(Nayin.涧下水.wuxing == .shui)
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
