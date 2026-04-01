import Testing
@testable import ChineseAstrologyCalendar

// MARK: - DizhiRelationshipTests

@Suite struct DizhiRelationshipTests {

  // MARK: - Chong (六冲) tests

  /// Each branch's chong partner is 6 positions away.
  @Test func chongPartners() {
    // 子午冲
    #expect(Dizhi.zi.chong == .wu)
    #expect(Dizhi.wu.chong == .zi)
    // 丑未冲
    #expect(Dizhi.chou.chong == .wei)
    #expect(Dizhi.wei.chong == .chou)
    // 寅申冲
    #expect(Dizhi.yin.chong == .shen)
    #expect(Dizhi.shen.chong == .yin)
    // 卯酉冲
    #expect(Dizhi.mao.chong == .you)
    #expect(Dizhi.you.chong == .mao)
    // 辰戌冲
    #expect(Dizhi.chen.chong == .xu)
    #expect(Dizhi.xu.chong == .chen)
    // 巳亥冲
    #expect(Dizhi.si.chong == .hai)
    #expect(Dizhi.hai.chong == .si)
  }

  /// clashes(with:) is symmetric.
  @Test func chongIsSymmetric() {
    for dizhi in Dizhi.allCases {
      #expect(dizhi.clashes(with: dizhi.chong), "\(dizhi.chineseCharacter) should clash with its chong partner")
      #expect(dizhi.chong.clashes(with: dizhi), "Chong relationship must be symmetric")
    }
  }

  /// No branch clashes with itself.
  @Test func noSelfClash() {
    for dizhi in Dizhi.allCases {
      #expect(!dizhi.clashes(with: dizhi), "\(dizhi.chineseCharacter) should not clash with itself")
    }
  }

  /// Chong pairs are all accounted for in the enum.
  @Test func chongEnumCoversAllPairs() {
    // There are exactly 6 chong pairs for 12 branches
    #expect(DizhiRelationship.Chong.allCases.count == 6)
    for pair in DizhiRelationship.Chong.allCases {
      let (a, b) = pair.branches
      #expect(a.clashes(with: b))
      #expect(b.clashes(with: a))
    }
  }

  // MARK: - LiuHe (六合) tests

  /// Known six-harmony pairs.
  @Test func liuHePairs() {
    #expect(Dizhi.zi.formsLiuHe(with: .chou))
    #expect(Dizhi.chou.formsLiuHe(with: .zi))
    #expect(Dizhi.yin.formsLiuHe(with: .hai))
    #expect(Dizhi.hai.formsLiuHe(with: .yin))
    #expect(Dizhi.mao.formsLiuHe(with: .xu))
    #expect(Dizhi.xu.formsLiuHe(with: .mao))
    #expect(Dizhi.chen.formsLiuHe(with: .you))
    #expect(Dizhi.you.formsLiuHe(with: .chen))
    #expect(Dizhi.si.formsLiuHe(with: .shen))
    #expect(Dizhi.shen.formsLiuHe(with: .si))
    #expect(Dizhi.wu.formsLiuHe(with: .wei))
    #expect(Dizhi.wei.formsLiuHe(with: .wu))
  }

  /// LiuHe resulting elements are correct.
  @Test func liuHeResultingElements() {
    #expect(Dizhi.zi.liuHe(with: .chou)?.resultingElement == .earth)   // 子丑合化土
    #expect(Dizhi.yin.liuHe(with: .hai)?.resultingElement == .wood)   // 寅亥合化木
    #expect(Dizhi.mao.liuHe(with: .xu)?.resultingElement == .fire)  // 卯戌合化火
    #expect(Dizhi.chen.liuHe(with: .you)?.resultingElement == .metal) // 辰酉合化金
    #expect(Dizhi.si.liuHe(with: .shen)?.resultingElement == .water) // 巳申合化水
    #expect(Dizhi.wu.liuHe(with: .wei)?.resultingElement == .fire)  // 午未合化火
  }

  /// LiuHe is nil for non-harmony pairs.
  @Test func liuHeNilForNonPairs() {
    #expect(Dizhi.zi.liuHe(with: .zi) == nil)
    #expect(Dizhi.zi.liuHe(with: .wu) == nil) // chong pair, not liuHe
    #expect(Dizhi.zi.liuHe(with: .yin) == nil)
  }

  // MARK: - SanHe (三合) tests

  /// Known three-harmony triads.
  @Test func sanHeTriads() {
    // 申子辰三合水局
    let waterTriad = Dizhi.shen.sanHe(with: .zi, and: .chen)
    #expect(waterTriad == .shenZiChen)
    #expect(waterTriad?.resultingElement == .water)

    // 寅午戌三合火局
    let fireTriad = Dizhi.yin.sanHe(with: .wu, and: .xu)
    #expect(fireTriad == .yinWuXu)
    #expect(fireTriad?.resultingElement == .fire)

    // 巳酉丑三合金局
    let metalTriad = Dizhi.si.sanHe(with: .you, and: .chou)
    #expect(metalTriad == .siYouChou)
    #expect(metalTriad?.resultingElement == .metal)

    // 亥卯未三合木局
    let woodTriad = Dizhi.hai.sanHe(with: .mao, and: .wei)
    #expect(woodTriad == .haiMaoWei)
    #expect(woodTriad?.resultingElement == .wood)
  }

  /// SanHe triad membership.
  @Test func sanHeTriadMembership() {
    // 子 belongs to 申子辰 (water)
    #expect(Dizhi.zi.sanHeTriads.contains(.shenZiChen))
    // 午 belongs to 寅午戌 (fire)
    #expect(Dizhi.wu.sanHeTriads.contains(.yinWuXu))
    // 辰 belongs to 申子辰 (water)
    #expect(Dizhi.chen.sanHeTriads.contains(.shenZiChen))
    // 酉 belongs to 巳酉丑 (metal)
    #expect(Dizhi.you.sanHeTriads.contains(.siYouChou))
  }

  /// Each branch is in exactly one SanHe triad.
  @Test func eachBranchInExactlyOneSanHeTriad() {
    for dizhi in Dizhi.allCases {
      #expect(dizhi.sanHeTriads.count == 1,
              "\(dizhi.chineseCharacter) should be in exactly 1 SanHe triad, got \(dizhi.sanHeTriads.count)")
    }
  }

  // MARK: - LiuHai (六害) tests

  /// Known harm pairs.
  @Test func liuHaiPairs() {
    #expect(Dizhi.zi.formsLiuHai(with: .wei))
    #expect(Dizhi.wei.formsLiuHai(with: .zi))
    #expect(Dizhi.chou.formsLiuHai(with: .wu))
    #expect(Dizhi.wu.formsLiuHai(with: .chou))
    #expect(Dizhi.yin.formsLiuHai(with: .si))
    #expect(Dizhi.si.formsLiuHai(with: .yin))
    #expect(Dizhi.mao.formsLiuHai(with: .chen))
    #expect(Dizhi.chen.formsLiuHai(with: .mao))
    #expect(Dizhi.shen.formsLiuHai(with: .hai))
    #expect(Dizhi.hai.formsLiuHai(with: .shen))
    #expect(Dizhi.you.formsLiuHai(with: .xu))
    #expect(Dizhi.xu.formsLiuHai(with: .you))
  }

  /// LiuHai is nil for non-harm pairs.
  @Test func liuHaiNilForNonPairs() {
    #expect(Dizhi.zi.liuHai(with: .zi) == nil)
    #expect(Dizhi.zi.liuHai(with: .wu) == nil) // chong, not harm
    #expect(Dizhi.zi.liuHai(with: .chou) == nil) // liuHe, not harm
  }

  /// Exactly 6 harm pairs covering all 12 branches.
  @Test func liuHaiCoversAllBranches() {
    #expect(DizhiRelationship.LiuHai.allCases.count == 6)
    var covered = Set<Dizhi>()
    for pair in DizhiRelationship.LiuHai.allCases {
      let (a, b) = pair.branches
      covered.insert(a)
      covered.insert(b)
    }
    #expect(covered.count == 12)
  }
}
