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

// MARK: - Whole-package coverage

/// Every `LocalizedNaming` value in the package, with every case of each type.
private var everyLocalizedValue: [any LocalizedNaming] {
  var values: [any LocalizedNaming] = []
  values += Tiangan.allCases
  values += Dizhi.allCases
  values += getJiazhi()
  values += Dizhi.allCases.map { Zodiac($0) }
  values += Nayin.allCases
  values += Wuxing.allCases
  values += FangWei.allCases
  values += Season.allCases
  values += Jieqi.allCases
  values += ChineseFestival.allCases
  values += ChineseMoonPhase.allCases
  values += TwelveGods.allCases
  values += LunarMansion.allCases
  values += [FourSymbol.azureDragon, .vermilionBird, .whiteTiger, .blackTortoise]
  values += Day.allCases
  values += (1...12).compactMap { LunarMonth(number: $0) }
  values += (1...12).compactMap { LunarMonth(number: $0, isLeap: true) }
  values += DizhiRelationship.Chong.allCases
  values += DizhiRelationship.LiuHe.allCases
  values += DizhiRelationship.SanHe.allCases
  values += DizhiRelationship.LiuHai.allCases
  values += SeasonalCount.Kind.allCases
  values += SeasonalCount.Kind.allCases.flatMap { kind in
    (0..<kind.periodCount).map { SeasonalCount.Period(kind: kind, index: $0) }
  }
  return values
}

private func containsHan(_ text: String) -> Bool {
  text.unicodeScalars.contains { $0.properties.isIdeographic }
}

@Suite struct EveryLanguageCoverageTests {

  @Test(arguments: DisplayLanguage.allCases)
  func everyNameIsNonEmpty(language: DisplayLanguage) {
    for value in everyLocalizedValue {
      #expect(!value.localizedName(in: language).isEmpty, "\(value) in \(language)")
    }
  }

  @Test(arguments: [DisplayLanguage.en, .es])
  func nonChineseNamesContainNoHanCharacters(language: DisplayLanguage) {
    for value in everyLocalizedValue {
      let name = value.localizedName(in: language)
      #expect(!containsHan(name), "\(value) in \(language): \(name)")
    }
  }
}

@Suite struct SpanishCoverageTests {

  /// Stems, branches and stem-branch pairs are Pinyin in both languages, and
  /// "Metal" is the same word in both.
  @Test func spanishNeverFallsBackToEnglish() {
    for value in everyLocalizedValue {
      if value is Tiangan || value is Dizhi || value is Ganzhi || value as? Wuxing == .metal { continue }
      let spanish = value.localizedName(in: .es)
      #expect(spanish != value.localizedName(in: .en), "\(value): \(spanish)")
    }
  }

  @Test func namesAreUniqueWithinAType() {
    func expectUnique(_ values: [any LocalizedNaming]) {
      let names = values.map { $0.localizedName(in: .es) }
      #expect(Set(names).count == names.count, "\(names)")
    }
    expectUnique(Nayin.allCases)
    expectUnique(LunarMansion.allCases)
    expectUnique(TwelveGods.allCases)
    expectUnique(ChineseMoonPhase.allCases)
    expectUnique(Jieqi.allCases)
    expectUnique(ChineseFestival.allCases)
    expectUnique(Day.allCases)
  }

  @Test func terms() {
    #expect(Tiangan.jia.localizedName(in: .es) == "Jiǎ")
    #expect(Dizhi.zi.localizedName(in: .es) == "Zǐ")
    #expect(Dizhi.zi.localizedHourName(in: .es) == "Hora Zǐ")
    #expect(Ganzhi(.kui, .mao)?.localizedName(in: .es) == "Guǐmǎo")
    #expect(Zodiac.dragon.localizedName(in: .es) == "Dragón")
    #expect(Nayin.seaGold.localizedName(in: .es) == "Oro en el mar")
    #expect(Wuxing.wood.localizedName(in: .es) == "Madera")
    #expect(FangWei.center.localizedName(in: .es) == "Centro")
    #expect(Season.fall.localizedName(in: .es) == "Otoño")
    #expect(ChineseMoonPhase.firstQuarter.localizedName(in: .es) == "Cuarto creciente")
    #expect(TwelveGods.opening.localizedName(in: .es) == "Apertura")
    #expect(LunarMansion.horn.localizedName(in: .es) == "Cuerno")
    #expect(FourSymbol.blackTortoise.localizedName(in: .es) == "Tortuga Negra")
    #expect(Day.day1.localizedName(in: .es) == "Día 1")
    #expect(LunarMonth(number: 1)?.localizedName(in: .es) == "1.er mes")
    #expect(LunarMonth(number: 3)?.localizedName(in: .es) == "3.er mes")
    #expect(LunarMonth(number: 4, isLeap: true)?.localizedName(in: .es) == "4.º mes intercalar")
    #expect(SeasonalCount.Kind.dogDays.localizedName(in: .es) == "Canícula")
    #expect(SeasonalCount.Period(kind: .nines, index: 2).localizedName(in: .es) == "Tercer nueve")
  }

  @Test func relationships() {
    #expect(DizhiRelationship.Chong.ziWu.localizedName(in: .es) == "Choque Zǐ–Wǔ")
    #expect(DizhiRelationship.LiuHe.ziChou.localizedName(in: .es) == "Armonía Zǐ–Chǒu")
    #expect(DizhiRelationship.SanHe.shenZiChen.localizedName(in: .es) == "Tríada Shēn–Zǐ–Chén")
    #expect(DizhiRelationship.LiuHai.ziWei.localizedName(in: .es) == "Daño Zǐ–Wèi")
  }

  @Test func elementColorsAndFlavors() {
    for element in Wuxing.allCases {
      #expect(element.localizedColorDescription(in: .es) != element.localizedColorDescription(in: .en))
      #expect(element.localizedFlavor(in: .es) != element.localizedFlavor(in: .en))
      #expect(!containsHan(element.localizedColorDescription(in: .es)))
      #expect(!containsHan(element.localizedFlavor(in: .es)))
    }
    #expect(Wuxing.earth.localizedColorDescription(in: .es) == "Amarillo")
    #expect(Wuxing.water.localizedFlavor(in: .es) == "Salado")
  }

  @Test func everyKe() {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = .chinaStandardTime
    let start = calendar.date(from: DateComponents(year: 2024, month: 2, day: 10, hour: 11))!
    let names = (0..<8).map { ke in
      Shichen(
        dizhi: .wu,
        date: start.addingTimeInterval(Double(ke) * Shichen.keLength + 60),
        calendar: calendar,
        timeZone: .chinaStandardTime
      ).localizedKeSpellOut(in: .es)
    }
    #expect(names == ["1.º", "2.º", "3.º", "4.º", "5.º", "6.º", "7.º", "8.º"])
  }

  @Test func lunarDateStyles() throws {
    let month = try #require(LunarMonth(number: 5))
    let tiger = LunarDate(year: try #require(Ganzhi(.ren, .yin)), month: month, day: .day9)
    #expect(tiger.formatted(.day, in: .es) == "Día 9")
    #expect(tiger.formatted(.monthDay, in: .es) == "Día 9 del 5.º mes")
    #expect(tiger.formatted(.yearMonthDay, in: .es) == "Día 9 del 5.º mes, año Rényín")
    #expect(tiger.formatted(.yearZodiacMonthDay, in: .es) == "Día 9 del 5.º mes, año del Tigre (Rényín)")
  }

  /// "del" before masculine animal names, "de la" before feminine ones.
  @Test func zodiacYearAgreesInGender() {
    let phrases = Dizhi.allCases.map { branch -> String in
      let year = getJiazhi().first { $0.zhi == branch }!
      let date = LunarDate(year: year, month: LunarMonth(number: 1)!, day: .day1)
      let text = date.formatted(.yearZodiacMonthDay, in: .es)
      return text.components(separatedBy: ", año ")[1].components(separatedBy: " (")[0]
    }
    #expect(phrases == [
      "de la Rata", "del Buey", "del Tigre", "del Conejo", "del Dragón", "de la Serpiente",
      "del Caballo", "de la Cabra", "del Mono", "del Gallo", "del Perro", "del Cerdo",
    ])
  }

  @Test func baziAndEventTitle() {
    let bazi = Bazi(
      nian: Ganzhi(gan: .kui, zhi: .mao),
      yue: Ganzhi(gan: .wu, zhi: .wu),
      ri: Ganzhi(gan: .xin, zhi: .si),
      shi: Ganzhi(gan: .kui, zhi: .chou))
    #expect(bazi.localizedFormattedDescription(in: .es)
      == "Año: Guǐmǎo (癸卯)  Mes: Wùwǔ (戊午)  Día: Xīnsì (辛巳)  Hora: Guǐchǒu (癸丑)")
    let event = EventModel(date: Date(), name: .day1, dateComponents: DateComponents(month: 1, day: 1))
    #expect(event.localizedTitle(in: .es) == "Día 1 del 1.er mes")
  }

  @Test func providerCategories() {
    #expect(LocalizedFestivalContentProvider(language: .es).category == "Festividad")
    #expect(LocalizedJieqiContentProvider(language: .es).category == "Término solar")
    #expect(LocalizedFestivalContentProvider(language: .ru).category != "Festival")
  }
}
