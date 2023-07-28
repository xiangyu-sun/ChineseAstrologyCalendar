import XCTest
@testable import ChineseAstrologyCalendar

final class QijieDizhiTests: XCTestCase {

  static var allTests = [
    ("testYin", testJieQiPairs),
  ]

  func testJieQiPairs() {
    XCTAssertEqual(
      Dizhi.allCases.map(\.jie),
      [
        ChineseAstrologyCalendar.Jieqi.lichun,
        ChineseAstrologyCalendar.Jieqi.jingzhe,
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
      ])

    XCTAssertEqual(
      Dizhi.allCases.map(\.qi),
      [
        ChineseAstrologyCalendar.Jieqi.yushui,
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
      ])
  }

}
