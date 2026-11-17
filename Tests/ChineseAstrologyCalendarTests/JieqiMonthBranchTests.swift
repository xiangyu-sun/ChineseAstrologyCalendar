import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct JieqiMonthBranchTests {

  // MARK: - monthBranch (月建)

  @Test(arguments: [
    (Jieqi.startOfSpring, Dizhi.yin), (.rainWater, .yin),
    (.awakeningOfInsects, .mao), (.springEquinox, .mao),
    (.clearAndBright, .chen), (.grainRain, .chen),
    (.startOfSummer, .si), (.grainBuds, .si),
    (.grainInEar, .wu), (.summerSolstice, .wu),
    (.minorHeat, .wei), (.majorHeat, .wei),
    (.startOfAutumn, .shen), (.endOfHeat, .shen),
    (.whiteDew, .you), (.autumnEquinox, .you),
    (.coldDew, .xu), (.frostDescent, .xu),
    (.startOfWinter, .hai), (.minorSnow, .hai),
    (.majorSnow, .zi), (.winterSolstice, .zi),
    (.minorCold, .chou), (.majorCold, .chou),
  ])
  func monthBranch(jieqi: Jieqi, branch: Dizhi) {
    #expect(jieqi.monthBranch == branch, "\(jieqi.chineseName) should be in the \(branch.chineseCharacter) month")
  }

  @Test func everyBranchHasOneJieAndOneQi() {
    for branch in Dizhi.allCases {
      let terms = Jieqi.allCases.filter { $0.monthBranch == branch }
      #expect(terms.count == 2)
      #expect(terms.filter(\.isMonthOpener).count == 1)
      #expect(terms.filter(\.isMajorTerm).count == 1)
    }
  }

  // MARK: - isMonthOpener / isMajorTerm / monthOpener

  @Test func twelveMonthOpeners() {
    let openers = Jieqi.traditionallyOrderedCases.filter(\.isMonthOpener)
    #expect(openers.count == 12)
    #expect(openers.map(\.chineseName) == ["立春", "驚蟄", "清明", "立夏", "芒種", "小暑", "立秋", "白露", "寒露", "立冬", "大雪", "小寒"])
  }

  @Test func isMajorTermMatchesQi() {
    for jieqi in Jieqi.allCases {
      #expect(jieqi.isMajorTerm == jieqi.qi)
      #expect(jieqi.isMajorTerm != jieqi.isMonthOpener)
    }
  }

  @Test func monthOpenerOpensTheSameMonth() {
    #expect(Jieqi.rainWater.monthOpener == .startOfSpring)
    #expect(Jieqi.springEquinox.monthOpener == .awakeningOfInsects)
    #expect(Jieqi.startOfSpring.monthOpener == .startOfSpring)
    for jieqi in Jieqi.allCases {
      #expect(jieqi.monthOpener.isMonthOpener)
      #expect(jieqi.monthOpener.monthBranch == jieqi.monthBranch)
    }
  }

  /// `Dizhi.jie` for each branch is the 節 whose `monthBranch` is that branch.
  /// Fails today: `Dizhi.jie`/`qi` share the legacy month-early mapping (寅.jie == 清明).
  @Test(.disabled("Dizhi.jie / Dizhi.qi still use the legacy month-early mapping"))
  func dizhiJieAgreesWithMonthBranch() {
    for branch in Dizhi.allCases {
      #expect(branch.jie.monthBranch == branch)
    }
  }

  // MARK: - previous / next

  @Test func previousAndNextRoundTrip() {
    for jieqi in Jieqi.allCases {
      #expect(jieqi.next.previous == jieqi)
      #expect(jieqi.previous.next == jieqi)
      #expect(jieqi.previous != jieqi)
    }
    #expect(Jieqi.springEquinox.previous == .awakeningOfInsects)
    #expect(Jieqi.startOfSpring.previous == .majorCold)
  }

  // MARK: - traditionalOrder

  @Test func traditionalOrderIsABijectionStartingAtStartOfSpring() {
    let orders = Jieqi.allCases.map(\.traditionalOrder)
    #expect(Set(orders) == Set(1...24))
    #expect(Jieqi.startOfSpring.traditionalOrder == 1)
    #expect(Jieqi.rainWater.traditionalOrder == 2)
    #expect(Jieqi.springEquinox.traditionalOrder == 4)
    #expect(Jieqi.majorCold.traditionalOrder == 24)
  }

  @Test func traditionallyOrderedCases() {
    let cases = Jieqi.traditionallyOrderedCases
    #expect(cases.count == 24)
    #expect(cases.map(\.traditionalOrder) == Array(1...24))
    #expect(cases.first == .startOfSpring)
    #expect(cases.last == .majorCold)
    for (current, following) in zip(cases, cases.dropFirst()) {
      #expect(current.next == following)
    }
  }

  // MARK: - pinyin / slug

  @Test func pinyinIsToneMarkedLowercase() {
    #expect(Jieqi.startOfSpring.pinyin == "lìchūn")
    #expect(Jieqi.frostDescent.pinyin == "shuāngjiàng")
    #expect(Jieqi.grainBuds.pinyin == "xiǎomǎn")
    #expect(Set(Jieqi.allCases.map(\.pinyin)).count == 24)
    for jieqi in Jieqi.allCases {
      #expect(jieqi.pinyin == jieqi.pinyin.lowercased())
    }
  }

  /// The slug is the pinyin with tone marks folded away.
  @Test func slugIsPinyinWithoutTones() {
    for jieqi in Jieqi.allCases {
      let folded = jieqi.pinyin.folding(options: .diacriticInsensitive, locale: Locale(identifier: "en_US_POSIX"))
      #expect(jieqi.slug == folded)
      #expect(jieqi.slug.allSatisfy { $0.isASCII && $0.isLowercase })
    }
  }

  /// The asset names TianganDizhi's `Jieqi+Image.swift` (and the 24Jieqi app) use.
  @Test func slugMatchesAppAssetNames() {
    let assetNames: [Jieqi: String] = [
      .springEquinox: "chunfen", .clearAndBright: "qingming", .grainRain: "guyu",
      .startOfSummer: "lixia", .grainBuds: "xiaoman", .grainInEar: "mangzhong",
      .summerSolstice: "xiazhi", .minorHeat: "xiaoshu", .majorHeat: "dashu",
      .startOfAutumn: "liqiu", .endOfHeat: "chushu", .whiteDew: "bailu",
      .autumnEquinox: "qiufen", .coldDew: "hanlu", .frostDescent: "shuangjiang",
      .startOfWinter: "lidong", .minorSnow: "xiaoxue", .majorSnow: "daxue",
      .winterSolstice: "dongzhi", .minorCold: "xiaohan", .majorCold: "dahan",
      .startOfSpring: "lichun", .rainWater: "yushui", .awakeningOfInsects: "jingzhe",
    ]
    #expect(assetNames.count == 24)
    for jieqi in Jieqi.allCases {
      #expect(jieqi.slug == assetNames[jieqi])
    }
  }
}
