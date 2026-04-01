import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct QijieDizhiTests {

  @Test func jieQiPairs() {
    #expect(
      Dizhi.orderedMonthAlCases.map(\.jie) ==
      [
        ChineseAstrologyCalendar.Jieqi.clearAndBright,
        ChineseAstrologyCalendar.Jieqi.startOfSummer,
        ChineseAstrologyCalendar.Jieqi.grainInEar,
        ChineseAstrologyCalendar.Jieqi.minorHeat,
        ChineseAstrologyCalendar.Jieqi.startOfAutumn,
        ChineseAstrologyCalendar.Jieqi.whiteDew,
        ChineseAstrologyCalendar.Jieqi.coldDew,
        ChineseAstrologyCalendar.Jieqi.startOfWinter,
        ChineseAstrologyCalendar.Jieqi.majorSnow,
        ChineseAstrologyCalendar.Jieqi.minorCold,
        ChineseAstrologyCalendar.Jieqi.startOfSpring,
        ChineseAstrologyCalendar.Jieqi.awakeningOfInsects,
      ])

    #expect(
      Dizhi.orderedMonthAlCases.map(\.qi) ==
      [
        ChineseAstrologyCalendar.Jieqi.springEquinox,
        ChineseAstrologyCalendar.Jieqi.grainRain,
        ChineseAstrologyCalendar.Jieqi.grainBuds,
        ChineseAstrologyCalendar.Jieqi.summerSolstice,
        ChineseAstrologyCalendar.Jieqi.majorHeat,
        ChineseAstrologyCalendar.Jieqi.endOfHeat,
        ChineseAstrologyCalendar.Jieqi.autumnEquinox,
        ChineseAstrologyCalendar.Jieqi.frostDescent,
        ChineseAstrologyCalendar.Jieqi.minorSnow,
        ChineseAstrologyCalendar.Jieqi.winterSolstice,
        ChineseAstrologyCalendar.Jieqi.majorCold,
        ChineseAstrologyCalendar.Jieqi.rainWater
      ])
  }

}
