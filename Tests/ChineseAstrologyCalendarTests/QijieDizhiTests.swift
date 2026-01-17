import Foundation
import Testing
@testable import ChineseAstrologyCalendar

@Suite struct QijieDizhiTests {

  @Test func jieQiPairs() {
    #expect(
      Dizhi.orderedMonthAlCases.map(\.jie) ==
      [
        ChineseAstrologyCalendar.Jieqi.qingming,
        ChineseAstrologyCalendar.Jieqi.lixia,
        ChineseAstrologyCalendar.Jieqi.mangzhong,
        ChineseAstrologyCalendar.Jieqi.xiaoshu,
        ChineseAstrologyCalendar.Jieqi.liqiu,
        ChineseAstrologyCalendar.Jieqi.bailu,
        ChineseAstrologyCalendar.Jieqi.hanlu,
        ChineseAstrologyCalendar.Jieqi.lidong,
        ChineseAstrologyCalendar.Jieqi.daxue,
        ChineseAstrologyCalendar.Jieqi.xiaohan,
        ChineseAstrologyCalendar.Jieqi.lichun,
        ChineseAstrologyCalendar.Jieqi.jingzhe,
      ])

    #expect(
      Dizhi.orderedMonthAlCases.map(\.qi) ==
      [
        ChineseAstrologyCalendar.Jieqi.chunfen,
        ChineseAstrologyCalendar.Jieqi.guyu,
        ChineseAstrologyCalendar.Jieqi.xiaoman,
        ChineseAstrologyCalendar.Jieqi.xiazhi,
        ChineseAstrologyCalendar.Jieqi.dashu,
        ChineseAstrologyCalendar.Jieqi.chushu,
        ChineseAstrologyCalendar.Jieqi.qiufen,
        ChineseAstrologyCalendar.Jieqi.shuangjiang,
        ChineseAstrologyCalendar.Jieqi.xiaoxue,
        ChineseAstrologyCalendar.Jieqi.dongzhi,
        ChineseAstrologyCalendar.Jieqi.dahan,
        ChineseAstrologyCalendar.Jieqi.yushui
      ])
  }

}
