# ChineseAstrologyCalendar

[English](README.md) | **繁體中文** | [简体中文](README.zh-Hans.md)

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Platform](https://img.shields.io/badge/platform-iOS%2013.0%2B%20%7C%20macOS%2010.14%2B%20%7C%20watchOS%206.0%2B-lightgrey.svg)](https://developer.apple.com/swift/)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE.md)

一個功能完整的 Swift 套件，用於處理中國傳統農曆與命理概念。支援公曆與農曆互轉，並提供生肖、月相、五行理論、八字四柱、納音、節日日期等豐富功能。

## ✨ 功能特色

### 📅 曆法轉換
- **Date 擴充**：將 `Date` 與 `DateComponents` 轉換為農曆數值
- **年／月／日／時柱**：取得四柱的干支（Ganzhi）表示
- **傳統格式**：以標準繁體中文格式顯示日期

### 🐲 生肖與干支系統
- **天干**：完整列舉十天干及其漢字
- **地支**：十二地支及其對應的生肖
- **六十甲子**：完整的六十年週期組合
- **Emoji 支援**：所有生肖皆有對應的圖示

### 🏮 八字四柱 — v1.4 新增
- **Bazi**：將年、月、日、時四柱干支組合為完整的命盤
- **日主**：由日柱判定自身五行
- **五行分析**：統計各五行數量，得出最旺、缺失與喜用五行
- 可直接由 `Date` 或四個明確指定的 `Ganzhi` 柱初始化

### 🎵 納音五行 — v1.4 新增
- **Nayin**：三十種傳統納音說明（海中金、爐中火、大林木等）
- 六十甲子每一組合皆可透過 `Ganzhi.nayin` 對應到納音
- `Nayin.wuxing`：各納音所屬的底層五行

### 🏮 地支關係 — v1.4 新增
- **六沖**：六組相沖 — `Dizhi.zi.chong` → `.wu`；`clashes(with:)`
- **六合**：六組相合，並附帶合化的五行
- **三合**：四組三合局及其五行（申子辰水局、寅午戌火局等）
- **六害**：六組相害
- 查詢方法：`liuHe(with:)`、`formsLiuHe(with:)`、`sanHe(with:and:)`、`sanHeTriads`、`liuHai(with:)`、`formsLiuHai(with:)`

### 🎊 傳統節日
- **12 個節日**：春節、元宵、龍抬頭、清明、端午、七夕、中元、中秋、重陽、冬至、臘八、小年
- `ChineseFestival.nextDate(from:converter:)` — 查找下一個公曆日期
- `Date.chineseFestival` — 回傳指定日期（若有）所對應的節日
- `Date.nextChineseFestival()` — 回傳最近的 `(festival, date)` 元組
- 節氣類節日（清明、冬至）透過 `Jieqi` 自動判定

### 🔌 可插拔的特殊日來源 — v2.1 新增
- **`SpecialDaySource` 協定**：實作 `specialDays(on:)` 與 `nextSpecialDay(after:)` 即可加入自訂事件來源
- **`FestivalSource`**：內建傳統節日來源；可注入 `ChineseFestivalContentProvider` 自訂名稱與說明
- **`JieqiSource`**：內建節氣交節日來源；可注入 `JieqiContentProvider` 提供在地化字串
- **`Date.specialDays(sources:)`**：回傳指定來源在某日的所有特殊日
- **`Date.nextSpecialDay(sources:)`**：回傳所有來源中最近的下一個特殊日

### 🌙 農曆功能
- **農曆日期**：傳統農曆日（初一、初二等）
- **月相**：八種傳統月相（朔、望、弦月等）
- **日期搜尋**：透過 `DayConverter` 查找特定農曆日的下次出現日期

### ⏰ 傳統時間區段
- **時辰**：傳統兩小時一個時辰，附精確起訖時間
- **二十四節氣**：完整的節氣系統，附養生小提示

### 🌤️ 節氣 API — v2.2+ 新增
- **`JieqiOccurrence`**：將 `Jieqi` 與其 `startDate` 綁定，呼叫端無需自行計算
- **`Date.currentJieqi`** → `JieqiOccurrence?` — 目前所處的節氣及其起始時間
- **`Date.nextJieqi`** → `JieqiOccurrence?` — 下一次節氣交接及其確切時間
- **`Jieqi.startDate(in:)`** → `Date?` — 包含指定日期的節氣期間的起點
- **`Jieqi.nextOccurrence(after:)`** → `JieqiOccurrence?` — 指定節氣下一次出現的時間

### 🔥 五行理論
- **五行**：木、火、土、金、水，含相生與相剋循環
- **方位**：基本方位與中間方位及其五行屬性
- **季節**：季節與五行的對應
- **轉換協定**：方便與自訂型別整合

### 🏛️ 進階功能
- **二十八宿**：傳統星宿系統
- **建除十二神**：每日的十二神及宜忌事項
- **事件模型**：含標題與說明的豐富事件表示
- **陰陽理論**：所有元件皆內建陰陽極性

### 📆 一站式黃曆 — v4.0 新增
- **`ChineseAlmanac`**：一次設定時區與語言，之後只需呼叫 `day(for:)`
- **`AlmanacDay`**：將農曆日期、四柱、節氣、節日、十二神、二十八宿、月相與時辰整合為一個 `Sendable` 值
- **`AlmanacDay.text`**：上述所有數值皆已本地化
- **`LunarDate`**：農曆年、月、日，可透過 `formatted(_:in:)` 以任何語言格式化

### 🌐 本地化 — v4.0 擴充
- **`DisplayLanguage`**：繁體中文（標準）、簡體中文、英文、俄文與西班牙文。它是 struct，因此日後新增語言不屬於破壞性變更
- 俄文與西班牙文翻譯了節日與節氣（名稱與說明）；其他型別會回退為英文
- **`LocalizedNaming`**：以一個 `localizedName(in:)` 呼叫即可取得 Zodiac、Tiangan、Dizhi、Ganzhi、Wuxing、Season、FangWei、Jieqi、ChineseFestival、ChineseMoonPhase、TwelveGods、Nayin、LunarMansion、FourSymbol、DizhiRelationship、Day 與 `LunarMonth` 的顯示名稱
- 下游套件可為自己的型別採用 `LocalizedNaming`

## 📱 平台支援

- **iOS**：13.0+
- **macOS**：10.14+
- **watchOS**：6.0+
- **Swift**：6.0+

## 🚀 安裝

### Swift Package Manager

在 `Package.swift` 中加入：

```swift
dependencies: [
    .package(url: "https://github.com/xiangyu-sun/ChineseAstrologyCalendar.git", from: "4.0.0")
]
```

或透過 Xcode 加入：
1. File → Add Packages
2. 輸入：`https://github.com/xiangyu-sun/ChineseAstrologyCalendar.git`
3. 點選 Add Package

## 📖 使用範例

### 快速開始：ChineseAlmanac

`ChineseAlmanac` 是建議 App 使用的入口。它預設以中國標準時間（UTC+8）計算日期，
因此無論裝置位於何處，結果都與印刷版黃曆一致。

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

// 一週檢視，每天一個值：
let week = almanac.days(from: Date(), count: 7)
```

`AlmanacDay` 是單純的 `Sendable` 值：可以快取、在 SwiftUI 中做 diff，或傳給
Widget 時間軸。下方的 `Date` 擴充仍可用於它未涵蓋的功能。

### 本地化顯示名稱

模型型別本身與語言無關；需要哪種語言的顯示字串，就向它索取。

```swift
let language = DisplayLanguage(identifier: Bundle.main.preferredLocalizations.first ?? "en")

Zodiac.dragon.localizedName(in: .zhHans)        // "龙"
Ganzhi(.kui, .mao)!.localizedName(in: .en)      // "Guǐmǎo"
Date().lunarMonth()?.localizedName(in: language) // "臘月" / "腊月" / "12th Month"
Dizhi.zi.localizedHourName(in: .zhHans)         // "子时"
LunarMansion.chariot.localizedName(in: .en)     // "Chariot"
```

建議使用 `Bundle.main.preferredLocalizations` 而非 `Locale.current`：它反映的是
App 介面實際顯示的語言。長篇文字（節氣養生提示、十二神黃曆說明）維持繁體中文，
僅手寫的俄文與西班牙文節氣說明除外。

`DisplayLanguage` 是 struct，因此對它做 switch 時請加上 `default:` 分支：

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

> **從 3.x 升級？** 請參閱 [MIGRATION.md](MIGRATION.md) 了解 4.0 的破壞性變更。

### 基本日期轉換

```swift
import ChineseAstrologyCalendar

let today = Date()

// 取得農曆各項元件
let chineseComponents = today.dateComponentsFromChineseCalendar()
print(chineseComponents.nian?.description ?? "")  // 年柱（例如 "癸卯"）
print(chineseComponents.yue?.description ?? "")   // 月柱（例如 "甲子"）
print(chineseComponents.riZhu?.description ?? "") // 日柱（例如 "乙丑"）

// 以任何語言格式化農曆日期
let lunar = today.lunarDate(.chineseCalendarGTM8)
print(lunar?.formatted(.yearMonthDay, in: .zhHant) ?? "")       // "癸卯年二月初三"
print(lunar?.formatted(.yearZodiacMonthDay, in: .zhHans) ?? "") // "癸卯兔年二月初三"
print(lunar?.formatted(.monthDay, in: .en) ?? "")               // "2nd Month 3rd"
```

### 八字四柱

```swift
// 由日期建立命盤（使用中國標準時間）
if let bazi = Bazi(date: Date()) {
    print(bazi.formattedDescription)
    // "年:甲辰 月:壬子 日:戊午 時:庚午"

    print(bazi.dayMaster.chineseCharacter)     // "戊" — 日主
    print(bazi.dayMasterElement.chineseCharacter) // "土"
    print(bazi.dominantElement.chineseCharacter)  // 出現最多的五行
    print(bazi.missingElements.map(\.chineseCharacter)) // 例如 ["木"]
    print(bazi.beneficialElement.chineseCharacter) // 扶助日主的五行
}
```

### 地支關係

```swift
// 六沖
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

### 納音五行

```swift
let jiaZi = Ganzhi(.jia, .zi)!
print(jiaZi.nayin)            // seaGold (海中金)
print(jiaZi.nayin.wuxing)     // .metal

let bingYin = Ganzhi(.bing, .yin)!
print(bingYin.nayin)          // furnaceFire (爐中火)
```

### 傳統節日

```swift
let converter = DayConverter()

// 查找下一個春節
if let cny = ChineseFestival.springFestival.nextDate(from: Date(), converter: converter) {
    print("Next Spring Festival: \(cny)")
}

// 檢查今天是否為節日
if let festival = Date().chineseFestival {
    print("Today is \(festival.chineseName): \(festival.meaning)")
}

// 取得最近的下一個節日（任何節日）
if let (festival, date) = Date().nextChineseFestival() {
    print("Next festival: \(festival.chineseName) on \(date)")
}
```

### 特殊日來源（可插拔）

```swift
// 內建來源
let today = Date().specialDays(sources: [FestivalSource(), JieqiSource()])

// 跨所有來源取得下一個特殊日
if let result = Date().nextSpecialDay(sources: [FestivalSource(), JieqiSource()]) {
    print("\(result.day.name) in \(result.daysUntil) day(s)")
}

// 自訂來源
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

### 節氣

```swift
// 目前所處節氣及其起始日期
if let current = Date().currentJieqi {
    print("In \(current.jieqi.chineseName) since \(current.startDate)")
}

// 下一次節氣交接 — startDate 可直接使用，無需自行計算
if let next = Date().nextJieqi {
    print("\(next.jieqi.chineseName) starts on \(next.startDate)")
}

// 特定節氣下次何時出現？
if let occurrence = Jieqi.winterSolstice.nextOccurrence(after: Date()) {
    print("冬至: \(occurrence.startDate)")
}

// 指定日期所在節氣的起點
if let start = Jieqi.grainBuds.startDate(in: Date()) {
    print("小滿 started on \(start)")
}
```

### 使用傳統時間區段

```swift
// 目前的時辰（兩小時一個時辰）
if let currentShichen = Date().shichen {
    print("Current period: \(currentShichen.dizhi.chineseCharacter)")
    print("Started: \(currentShichen.startDate)")
    print("Ends: \(currentShichen.endDate)")
}
```

### 農曆日與月相資訊

```swift
// 使用農曆日
let lunarDay = Day.shiwu  // 十五日（滿月）
print(lunarDay.name)      // "十五"

// 搜尋即將到來的農曆日
let converter = DayConverter()
let fullMoons = converter.find(days: [.shiwu], inNextMonths: 6)
for moon in fullMoons {
    print("Full moon: \(moon.date)")
}
```

### 五行與生肖

```swift
// 使用干支與五行
let ganzhi = Ganzhi(.jia, .zi)!  // 甲子（不屬於六十甲子的組合會回傳 nil）
print(ganzhi.description)      // "甲子"
print(ganzhi.gan.wuxing)       // .wood
print(ganzhi.jiaziIndex)       // 0
print(Ganzhi(jiaziIndex: 39))  // 癸卯

// 五行關係
let wood = Wuxing.wood
print(wood.sheng.chineseCharacter)  // "火" — 木生火
print(wood.ke.chineseCharacter)     // "土" — 木剋土
```

## 🧪 測試

執行完整測試套件：

```bash
swift test
```

本套件包含 200 多項測試，涵蓋：
- 日期轉換準確度
- 干支計算
- 月相對應
- 節氣精確度
- 五行理論關係
- 地支沖／合／害關係
- 八字四柱分析
- 納音對應
- 節日日期準確度
- 整合情境

## 📚 文件

### 核心元件

- **`Date` 擴充**：與 Foundation 的 Date 型別無縫整合
- **`Ganzhi`**：天干地支組合
- **`Bazi`**：八字四柱命盤
- **`Nayin`**：各干支組合的納音
- **`DizhiRelationship`**：沖、合、害關係
- **`ChineseFestival`**：傳統節日日期查找
- **`JieqiOccurrence`**：將 `Jieqi` 與其 `startDate` 配對，便於安全處理日期
- **`SpecialDaySource`**：可插拔特殊日來源的協定
- **`FestivalSource`** / **`JieqiSource`**：內建特殊日來源
- **`Day`**：農曆日表示
- **`Shichen`**：傳統兩小時時辰
- **`Wuxing`**：五行理論實作
- **`ChineseMoonPhase`**：傳統月相系統
- **`Jieqi`**：二十四節氣，含養生提示、出現時間查詢與前後節氣輔助方法

### 架構

```
ChineseAstrologyCalendar/
├── Date/                  # 日期轉換與格式化
├── DizhiGanzhi/           # 核心干支系統 + 地支關係 + 納音
├── FiveElements/          # 五行理論與關係
├── Event/                 # 事件模型
├── Jieqi/                 # 節氣、JieqiOccurrence、養生提示
├── Moon/                  # 月相
├── SpecialDaySources/     # FestivalSource、JieqiSource、可插拔提供者
├── Bazi.swift             # 八字四柱
├── ChineseFestival.swift  # 傳統節日日期
├── SpecialDay.swift       # SpecialDay + SpecialDaySource 協定
└── Math.swift             # 天文計算
```

## 🔧 相依套件

- [Swift Numerics](https://github.com/apple/swift-numerics)：高精度數學計算
- [Astral](https://github.com/xiangyu-sun/Astral)：天文計算工具

## 🤝 參與貢獻

歡迎貢獻！請隨時提交 Pull Request。若為重大變更，請先開 issue 討論您想修改的內容。

請參閱 [CONTRIBUTING.md](CONTRIBUTING.md) 了解貢獻指南。

## 📄 授權

本專案採用 MIT 授權 — 詳見 [LICENSE.md](LICENSE.md)。

## 🙏 致謝

- 傳統農曆演算法與天文計算
- 五行理論及其關係
- 二十八宿的歷史文獻
- 社群的回饋與貢獻

---

**注意**：本套件提供傳統農曆計算，用於文化、教育與歷史用途。天文計算為近似值，適合一般使用，但可能不適用於需要精確度的科學應用。
