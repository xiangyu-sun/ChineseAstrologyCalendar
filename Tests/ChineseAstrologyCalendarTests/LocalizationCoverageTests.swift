import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct LocalizationCoverageTests {

  // MARK: - DisplayLanguage

  @Test func explicitScriptWinsOverRegion() {
    #expect(DisplayLanguage(identifier: "zh-Hant-CN") == .zhHant)
    #expect(DisplayLanguage(identifier: "zh-Hans-HK") == .zhHans)
    #expect(DisplayLanguage(identifier: "zh_Hant_CN") == .zhHant)
    #expect(DisplayLanguage(identifier: "zh-HK") == .zhHant)
    #expect(DisplayLanguage(identifier: "zh-CN") == .zhHans)
    #expect(DisplayLanguage(identifier: "en-CN") == .en)
  }

  // MARK: - Ganzhi

  @Test func ganzhiPublicComponents() {
    let guimao = Ganzhi(.kui, .mao)
    #expect(guimao?.gan == .kui)
    #expect(guimao?.zhi == .mao)
    #expect(Ganzhi(.jia, .chou) == nil)
  }

  @Test func ganzhiJiaziIndexRoundTrips() {
    let cycle = getJiazhi()
    for (index, ganzhi) in cycle.enumerated() {
      #expect(ganzhi.jiaziIndex == index)
      #expect(Ganzhi(jiaziIndex: index) == ganzhi)
    }
    #expect(Ganzhi(jiaziIndex: 60) == Ganzhi(jiaziIndex: 0))
    #expect(Ganzhi(jiaziIndex: -1).description == "癸亥")
  }

  @Test func ganzhiLocalized() {
    let guimao = Ganzhi(.kui, .mao)!
    #expect(guimao.localizedName(in: .zhHant) == "癸卯")
    #expect(guimao.localizedName(in: .zhHans) == "癸卯")
    #expect(guimao.localizedName(in: .en) == "Guǐmǎo")
  }

  @Test func stemAndBranchLocalized() {
    #expect(Tiangan.jia.localizedName(in: .en) == "Jiǎ")
    #expect(Tiangan.jia.localizedName(in: .zhHans) == "甲")
    #expect(Dizhi.zi.localizedName(in: .en) == "Zǐ")
    #expect(Dizhi.zi.localizedHourName(in: .zhHant) == "子時")
    #expect(Dizhi.zi.localizedHourName(in: .zhHans) == "子时")
    #expect(Dizhi.zi.localizedHourName(in: .en) == "Zǐ hour")
  }

  // MARK: - Nayin

  @Test func nayinLocalized() {
    #expect(Nayin.furnaceFire.localizedName(in: .zhHant) == "爐中火")
    #expect(Nayin.furnaceFire.localizedName(in: .zhHans) == "炉中火")
    #expect(Nayin.seaGold.localizedName(in: .zhHans) == "海中金")
    #expect(Nayin.seaGold.localizedName(in: .en) == "Gold in the Sea")
    #expect(Nayin.lanternFire.traditionalChineseName == "覆燈火")
  }

  @Test func everyNayinHasEnglishName() {
    for nayin in Nayin.allCases {
      #expect(nayin.localizedName(in: .en) != nayin.traditionalChineseName)
    }
  }

  // MARK: - LunarMansion / FourSymbol

  @Test func lunarMansionLocalized() {
    #expect(LunarMansion.chariot.localizedName(in: .zhHant) == "軫宿")
    #expect(LunarMansion.chariot.localizedName(in: .zhHans) == "轸宿")
    #expect(LunarMansion.horn.localizedName(in: .zhHans) == "角宿")
    #expect(LunarMansion.pleiades.localizedName(in: .en) == "Hairy Head")
    for mansion in LunarMansion.allCases {
      #expect(mansion.localizedName(in: .en) != mansion.name)
    }
  }

  @Test func fourSymbolLocalized() {
    #expect(FourSymbol.azureDragon.localizedName(in: .zhHans) == "青龙")
    #expect(FourSymbol.azureDragon.localizedName(in: .zhHant) == "青龍")
    #expect(FourSymbol.blackTortoise.localizedName(in: .en) == "Black Tortoise")
  }

  // MARK: - DizhiRelationship

  @Test func dizhiRelationshipLocalized() {
    #expect(DizhiRelationship.Chong.ziWu.localizedName(in: .zhHant) == "子午沖")
    #expect(DizhiRelationship.Chong.ziWu.localizedName(in: .zhHans) == "子午冲")
    #expect(DizhiRelationship.Chong.ziWu.localizedName(in: .en) == "Zǐ–Wǔ Clash")
    #expect(DizhiRelationship.LiuHe.ziChou.localizedName(in: .en) == "Zǐ–Chǒu Harmony")
    #expect(DizhiRelationship.SanHe.shenZiChen.localizedName(in: .en) == "Shēn–Zǐ–Chén Triad")
    #expect(DizhiRelationship.LiuHai.ziWei.localizedName(in: .zhHant) == "子未害")
  }

  // MARK: - LunarMonth

  @Test func lunarMonthNames() {
    #expect(LunarMonth(number: 1)?.localizedName(in: .zhHant) == "正月")
    #expect(LunarMonth(number: 12)?.localizedName(in: .zhHant) == "臘月")
    #expect(LunarMonth(number: 12)?.localizedName(in: .zhHans) == "腊月")
    #expect(LunarMonth(number: 4, isLeap: true)?.localizedName(in: .zhHant) == "閏四月")
    #expect(LunarMonth(number: 4, isLeap: true)?.localizedName(in: .zhHans) == "闰四月")
    #expect(LunarMonth(number: 4, isLeap: true)?.localizedName(in: .en) == "Leap 4th Month")
    #expect(LunarMonth(number: 11)?.localizedName(in: .en) == "11th Month")
    #expect(LunarMonth(number: 13) == nil)
  }

  @Test func lunarMonthFromDate() {
    var calendar = Calendar(identifier: .chinese)
    calendar.timeZone = TimeZone(identifier: "Asia/Shanghai")!
    var gregorian = Calendar(identifier: .gregorian)
    gregorian.timeZone = calendar.timeZone
    // 2023-03-22 is the first day of 閏二月 in the 癸卯 year.
    let leapDay = gregorian.date(from: DateComponents(year: 2023, month: 3, day: 22, hour: 12))!
    #expect(leapDay.lunarMonth(calendar) == LunarMonth(number: 2, isLeap: true))
    // 2024-02-10 is Chinese New Year.
    let newYear = gregorian.date(from: DateComponents(year: 2024, month: 2, day: 10, hour: 12))!
    #expect(newYear.lunarMonth(calendar)?.localizedName(in: .zhHant) == "正月")
  }
}
