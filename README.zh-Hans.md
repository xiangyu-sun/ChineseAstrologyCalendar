# ChineseAstrologyCalendar

[English](README.md) | [繁體中文](README.zh-Hant.md) | **简体中文**

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Platform](https://img.shields.io/badge/platform-iOS%2013.0%2B%20%7C%20macOS%2010.14%2B%20%7C%20watchOS%206.0%2B-lightgrey.svg)](https://developer.apple.com/swift/)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE.md)

一个功能完整的 Swift 包，用于处理中国传统农历与命理概念。支持公历与农历互转，并提供生肖、月相、五行理论、八字四柱、纳音、节日日期等丰富功能。

## ✨ 功能特色

### 📅 历法转换
- **Date 扩展**：将 `Date` 与 `DateComponents` 转换为农历数值
- **年／月／日／时柱**：获取四柱的干支（Ganzhi）表示
- **传统格式**：以标准繁体中文格式显示日期

### 🐲 生肖与干支系统
- **天干**：完整枚举十天干及其汉字
- **地支**：十二地支及其对应的生肖
- **六十甲子**：完整的六十年周期组合
- **Emoji 支持**：所有生肖均有对应的图标

### 🏮 八字四柱 — v1.4 新增
- **Bazi**：将年、月、日、时四柱干支组合为完整的命盘
- **日主**：由日柱判定自身五行
- **五行分析**：统计各五行数量，得出最旺、缺失与喜用五行
- 可直接由 `Date` 或四个明确指定的 `Ganzhi` 柱初始化

### 🎵 纳音五行 — v1.4 新增
- **Nayin**：三十种传统纳音说明（海中金、炉中火、大林木等）
- 六十甲子每一组合均可通过 `Ganzhi.nayin` 对应到纳音
- `Nayin.wuxing`：各纳音所属的底层五行

### 🏮 地支关系 — v1.4 新增
- **六冲**：六组相冲 — `Dizhi.zi.chong` → `.wu`；`clashes(with:)`
- **六合**：六组相合，并附带合化的五行
- **三合**：四组三合局及其五行（申子辰水局、寅午戌火局等）
- **六害**：六组相害
- 查询方法：`liuHe(with:)`、`formsLiuHe(with:)`、`sanHe(with:and:)`、`sanHeTriads`、`liuHai(with:)`、`formsLiuHai(with:)`

### 🎊 传统节日
- **12 个节日**：春节、元宵、龙抬头、清明、端午、七夕、中元、中秋、重阳、冬至、腊八、小年
- `ChineseFestival.nextDate(from:converter:)` — 查找下一个公历日期
- `Date.chineseFestival` — 返回指定日期（若有）所对应的节日
- `Date.nextChineseFestival()` — 返回最近的 `(festival, date)` 元组
- 节气类节日（清明、冬至）通过 `Jieqi` 自动判定

### 🔌 可插拔的特殊日来源 — v2.1 新增
- **`SpecialDaySource` 协议**：实现 `specialDays(on:)` 与 `nextSpecialDay(after:)` 即可加入自定义事件来源
- **`FestivalSource`**：内置传统节日来源；可注入 `ChineseFestivalContentProvider` 自定义名称与说明
- **`JieqiSource`**：内置节气交节日来源；可注入 `JieqiContentProvider` 提供本地化字符串
- **`Date.specialDays(sources:)`**：返回指定来源在某日的所有特殊日
- **`Date.nextSpecialDay(sources:)`**：返回所有来源中最近的下一个特殊日

### 🌙 农历功能
- **农历日期**：传统农历日（初一、初二等）
- **月相**：八种传统月相（朔、望、弦月等）
- **日期搜索**：通过 `DayConverter` 查找特定农历日的下次出现日期

### ⏰ 传统时间区段
- **时辰**：传统两小时一个时辰，附精确起止时间
- **二十四节气**：完整的节气系统，附养生小提示

### 🌤️ 节气 API — v2.2+ 新增
- **`JieqiOccurrence`**：将 `Jieqi` 与其 `startDate` 绑定，调用方无需自行计算
- **`Date.currentJieqi`** → `JieqiOccurrence?` — 当前所处的节气及其起始时间
- **`Date.nextJieqi`** → `JieqiOccurrence?` — 下一次节气交接及其确切时间
- **`Jieqi.startDate(in:)`** → `Date?` — 包含指定日期的节气期间的起点
- **`Jieqi.nextOccurrence(after:)`** → `JieqiOccurrence?` — 指定节气下一次出现的时间

### 🔥 五行理论
- **五行**：木、火、土、金、水，含相生与相克循环
- **方位**：基本方位与中间方位及其五行属性
- **季节**：季节与五行的对应
- **转换协议**：方便与自定义类型集成

### 🏛️ 进阶功能
- **二十八宿**：传统星宿系统
- **建除十二神**：每日的十二神及宜忌事项
- **事件模型**：含标题与说明的丰富事件表示
- **阴阳理论**：所有组件均内置阴阳极性

### 📆 一站式黄历 — v4.0 新增
- **`ChineseAlmanac`**：一次设置时区与语言，之后只需调用 `day(for:)`
- **`AlmanacDay`**：将农历日期、四柱、节气、节日、十二神、二十八宿、月相与时辰整合为一个 `Sendable` 值
- **`AlmanacDay.text`**：上述所有数值均已本地化
- **`LunarDate`**：农历年、月、日，可通过 `formatted(_:in:)` 以任何语言格式化

### 🌐 本地化 — v4.0 扩展
- **`DisplayLanguage`**：繁体中文（标准）、简体中文、英文、俄文与西班牙文。它是 struct，因此日后新增语言不属于破坏性变更
- 俄文与西班牙文翻译了节日与节气（名称与说明）；其他类型会回退为英文
- **`LocalizedNaming`**：通过一个 `localizedName(in:)` 调用即可获取 Zodiac、Tiangan、Dizhi、Ganzhi、Wuxing、Season、FangWei、Jieqi、ChineseFestival、ChineseMoonPhase、TwelveGods、Nayin、LunarMansion、FourSymbol、DizhiRelationship、Day 与 `LunarMonth` 的显示名称
- 下游包可为自己的类型采用 `LocalizedNaming`

## 📱 平台支持

- **iOS**：13.0+
- **macOS**：10.14+
- **watchOS**：6.0+
- **Swift**：6.0+

## 🚀 安装

### Swift Package Manager

在 `Package.swift` 中添加：

```swift
dependencies: [
    .package(url: "https://github.com/xiangyu-sun/ChineseAstrologyCalendar.git", from: "4.0.0")
]
```

或通过 Xcode 添加：
1. File → Add Packages
2. 输入：`https://github.com/xiangyu-sun/ChineseAstrologyCalendar.git`
3. 点击 Add Package

## 📖 使用示例

### 快速开始：ChineseAlmanac

`ChineseAlmanac` 是推荐 App 使用的入口。它默认按中国标准时间（UTC+8）计算日期，
因此无论设备位于何处，结果都与印刷版黄历一致。

```swift
import ChineseAstrologyCalendar

let language = DisplayLanguage(identifier: Bundle.main.preferredLocalizations.first ?? "en")
let almanac = ChineseAlmanac(language: language)

let today = almanac.day(for: Date())
today.lunarDate          // on 2024-02-10: 甲辰年正月初一
today.festival           // .springFestival
today.jieqi?.jieqi       // .startOfSpring
today.twelveGod          // e.g. .establish
today.text.lunarDate     // "甲辰龍年正月初一" / "1st Month 1st, Year of the Dragon (Jiǎchén)"
today.text.festival      // "春節" / "Spring Festival" / "Праздник весны (Китайский Новый год)"

// 一周视图，每天一个值：
let week = almanac.days(from: Date(), count: 7)
```

`AlmanacDay` 是单纯的 `Sendable` 值：可以缓存、在 SwiftUI 中做 diff，或传给
Widget 时间线。下方的 `Date` 扩展仍可用于它未覆盖的功能。

### 本地化显示名称

模型类型本身与语言无关；需要哪种语言的显示字符串，就向它索取。

```swift
let language = DisplayLanguage(identifier: Bundle.main.preferredLocalizations.first ?? "en")

Zodiac.dragon.localizedName(in: .zhHans)        // "龙"
Ganzhi(.kui, .mao)!.localizedName(in: .en)      // "Guǐmǎo"
Date().lunarMonth()?.localizedName(in: language) // "臘月" / "腊月" / "12th Month"
Dizhi.zi.localizedHourName(in: .zhHans)         // "子时"
LunarMansion.chariot.localizedName(in: .en)     // "Chariot"
```

建议使用 `Bundle.main.preferredLocalizations` 而非 `Locale.current`：它反映的是
App 界面实际显示的语言。长篇文字（节气养生提示、十二神黄历说明）保持繁体中文，
仅手写的俄文与西班牙文节气说明除外。

`DisplayLanguage` 是 struct，因此对它做 switch 时请加上 `default:` 分支：

```swift
extension MyType: LocalizedNaming {
  func localizedName(in language: DisplayLanguage) -> String {
    switch language {
    case .zhHant: return "龍"
    case .zhHans: return "龙"
    default: return "Dragon"
    }
  }
}
```

> **从 3.x 升级？** 请参阅 [MIGRATION.md](MIGRATION.md) 了解 4.0 的破坏性变更。

### 基本日期转换

```swift
import ChineseAstrologyCalendar

let today = Date()

// 获取农历各项组件
let chineseComponents = today.dateComponentsFromChineseCalendar()
print(chineseComponents.nian?.description ?? "")  // 年柱（例如 "癸卯"）
print(chineseComponents.yue?.description ?? "")   // 月柱（例如 "甲子"）
print(chineseComponents.riZhu?.description ?? "") // 日柱（例如 "乙丑"）

// 以任何语言格式化农历日期
let lunar = today.lunarDate(.chineseCalendarGTM8)
print(lunar?.formatted(.yearMonthDay, in: .zhHant) ?? "")       // "癸卯年二月初三"
print(lunar?.formatted(.yearZodiacMonthDay, in: .zhHans) ?? "") // "癸卯兔年二月初三"
print(lunar?.formatted(.monthDay, in: .en) ?? "")               // "2nd Month 3rd"
```

### 八字四柱

```swift
// 由日期创建命盘（使用中国标准时间）
if let bazi = Bazi(date: Date()) {
    print(bazi.formattedDescription)
    // "年:甲辰 月:壬子 日:戊午 時:庚午"

    print(bazi.dayMaster.chineseCharacter)     // "戊" — 日主
    print(bazi.dayMasterElement.chineseCharacter) // "土"
    print(bazi.dominantElement.chineseCharacter)  // 出现最多的五行
    print(bazi.missingElements.map(\.chineseCharacter)) // 例如 ["木"]
    print(bazi.beneficialElement.chineseCharacter) // 扶助日主的五行
}
```

### 地支关系

```swift
// 六冲
print(Dizhi.zi.chong)               // .wu
print(Dizhi.zi.clashes(with: .wu))  // true

// 六合
let pair = Dizhi.zi.liuHe(with: .chou)
print(pair?.resultingElement.chineseCharacter ?? "") // "土"（子丑合化土）

// 三合
let triad = Dizhi.shen.sanHe(with: .zi, and: .chen)
print(triad?.resultingElement.chineseCharacter ?? "") // "水"（申子辰三合水局）

// 六害
print(Dizhi.zi.formsLiuHai(with: .wei))  // true
```

### 纳音五行

```swift
let jiaZi = Ganzhi(.jia, .zi)!
print(jiaZi.nayin)            // seaGold (海中金)
print(jiaZi.nayin.wuxing)     // .metal

let bingYin = Ganzhi(.bing, .yin)!
print(bingYin.nayin)          // furnaceFire (爐中火)
```

### 传统节日

```swift
let converter = DayConverter()

// 查找下一个春节
if let cny = ChineseFestival.springFestival.nextDate(from: Date(), converter: converter) {
    print("Next Spring Festival: \(cny)")
}

// 检查今天是否为节日
if let festival = Date().chineseFestival {
    print("Today is \(festival.chineseName): \(festival.meaning)")
}

// 获取最近的下一个节日（任何节日）
if let (festival, date) = Date().nextChineseFestival() {
    print("Next festival: \(festival.chineseName) on \(date)")
}
```

### 特殊日来源（可插拔）

```swift
// 内置来源
let today = Date().specialDays(sources: [FestivalSource(), JieqiSource()])

// 跨所有来源获取下一个特殊日
if let result = Date().nextSpecialDay(sources: [FestivalSource(), JieqiSource()]) {
    print("\(result.day.name) in \(result.daysUntil) day(s)")
}

// 自定义来源
struct GregorianNewYearSource: SpecialDaySource {
    func specialDays(on date: Date) -> [SpecialDay] {
        let comps = Calendar(identifier: .gregorian).dateComponents([.month, .day], from: date)
        guard comps.month == 1, comps.day == 1 else { return [] }
        return [SpecialDay(name: "元旦", category: "公曆節日", detail: "陽曆新年", date: date)]
    }
    func nextSpecialDay(after date: Date) -> SpecialDay? { nil }
}

let custom = Date().specialDays(sources: [FestivalSource(), JieqiSource(), GregorianNewYearSource()])
```

### 节气

```swift
// 当前所处节气及其起始日期
if let current = Date().currentJieqi {
    print("In \(current.jieqi.chineseName) since \(current.startDate)")
}

// 下一次节气交接 — startDate 可直接使用，无需自行计算
if let next = Date().nextJieqi {
    print("\(next.jieqi.chineseName) starts on \(next.startDate)")
}

// 特定节气下次何时出现？
if let occurrence = Jieqi.winterSolstice.nextOccurrence(after: Date()) {
    print("冬至: \(occurrence.startDate)")
}

// 指定日期所在节气的起点
if let start = Jieqi.grainBuds.startDate(in: Date()) {
    print("小滿 started on \(start)")
}
```

### 使用传统时间区段

```swift
// 当前的时辰（两小时一个时辰）
if let currentShichen = Date().shichen {
    print("Current period: \(currentShichen.dizhi.chineseCharacter)")
    print("Started: \(currentShichen.startDate)")
    print("Ends: \(currentShichen.endDate)")
}
```

### 农历日与月相信息

```swift
// 使用农历日
let lunarDay = Day.shiwu  // 十五日（满月）
print(lunarDay.name)      // "十五"

// 搜索即将到来的农历日
let converter = DayConverter()
let fullMoons = converter.find(days: [.shiwu], inNextMonths: 6)
for moon in fullMoons {
    print("Full moon: \(moon.date)")
}
```

### 五行与生肖

```swift
// 使用干支与五行
let ganzhi = Ganzhi(.jia, .zi)!  // 甲子（不属于六十甲子的组合会返回 nil）
print(ganzhi.description)      // "甲子"
print(ganzhi.gan.wuxing)       // .wood
print(ganzhi.jiaziIndex)       // 0
print(Ganzhi(jiaziIndex: 39))  // 癸卯

// 五行关系
let wood = Wuxing.wood
print(wood.sheng.chineseCharacter)  // "火" — 木生火
print(wood.ke.chineseCharacter)     // "土" — 木克土
```

## 🧪 测试

运行完整测试套件：

```bash
swift test
```

本包包含 200 多项测试，涵盖：
- 日期转换准确度
- 干支计算
- 月相对应
- 节气精确度
- 五行理论关系
- 地支冲／合／害关系
- 八字四柱分析
- 纳音对应
- 节日日期准确度
- 集成场景

## 📚 文档

### 核心组件

- **`Date` 扩展**：与 Foundation 的 Date 类型无缝集成
- **`Ganzhi`**：天干地支组合
- **`Bazi`**：八字四柱命盘
- **`Nayin`**：各干支组合的纳音
- **`DizhiRelationship`**：冲、合、害关系
- **`ChineseFestival`**：传统节日日期查找
- **`JieqiOccurrence`**：将 `Jieqi` 与其 `startDate` 配对，便于安全处理日期
- **`SpecialDaySource`**：可插拔特殊日来源的协议
- **`FestivalSource`** / **`JieqiSource`**：内置特殊日来源
- **`Day`**：农历日表示
- **`Shichen`**：传统两小时时辰
- **`Wuxing`**：五行理论实现
- **`ChineseMoonPhase`**：传统月相系统
- **`Jieqi`**：二十四节气，含养生提示、出现时间查询与前后节气辅助方法

### 架构

```
ChineseAstrologyCalendar/
├── Date/                  # 日期转换与格式化
├── DizhiGanzhi/           # 核心干支系统 + 地支关系 + 纳音
├── FiveElements/          # 五行理论与关系
├── Event/                 # 事件模型
├── Jieqi/                 # 节气、JieqiOccurrence、养生提示
├── Moon/                  # 月相
├── SpecialDaySources/     # FestivalSource、JieqiSource、可插拔提供者
├── Bazi.swift             # 八字四柱
├── ChineseFestival.swift  # 传统节日日期
├── SpecialDay.swift       # SpecialDay + SpecialDaySource 协议
└── Math.swift             # 天文计算
```

## 🔧 依赖

- [Swift Numerics](https://github.com/apple/swift-numerics)：高精度数学计算
- [Astral](https://github.com/xiangyu-sun/Astral)：天文计算工具

## 🤝 参与贡献

欢迎贡献！请随时提交 Pull Request。若为重大变更，请先开 issue 讨论您想修改的内容。

请参阅 [CONTRIBUTING.md](CONTRIBUTING.md) 了解贡献指南。

## 📄 许可证

本项目采用 MIT 许可证 — 详见 [LICENSE.md](LICENSE.md)。

## 🙏 致谢

- 传统农历算法与天文计算
- 五行理论及其关系
- 二十八宿的历史文献
- 社区的反馈与贡献

---

**注意**：本包提供传统农历计算，用于文化、教育与历史用途。天文计算为近似值，适合一般使用，但可能不适用于需要精确度的科学应用。
