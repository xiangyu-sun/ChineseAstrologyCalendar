# ChineseAstrologyCalendar

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Platform](https://img.shields.io/badge/platform-iOS%2013.0%2B%20%7C%20macOS%2010.15%2B%20%7C%20watchOS%206.0%2B-lightgrey.svg)](https://developer.apple.com/swift/)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE.md)

A comprehensive Swift package for working with traditional Chinese lunar calendar and astrology concepts. Convert between Gregorian and Chinese calendars, access zodiac animals, moon phases, five element theory, Bazi four pillars, Nayin sound elements, festival dates, and much more.

## ✨ Features

### 📅 Calendar Conversions
- **Date Extensions**: Convert `Date` and `DateComponents` to Chinese calendar values
- **Year/Month/Day/Hour Pillars**: Access Ganzhi (干支) representations for all four calendar pillars
- **Traditional Formatting**: Display dates in proper Traditional Chinese format

### 🐲 Zodiac & Ganzhi System
- **Heavenly Stems** (天干): Complete enumeration of the 10 stems with Chinese characters
- **Earthly Branches** (地支): All 12 branches with zodiac animal associations
- **Sixty Jiazi** (六十甲子): The complete 60-year cycle combinations
- **Emoji Support**: Visual representations for all zodiac animals

### 🏮 Four Pillars of Destiny (八字 Bazi) — New in v1.4
- **Bazi**: Combines year, month, day, and hour Ganzhi pillars into a complete birth chart
- **Day Master** (日主): Identifies the self element from the day pillar
- **Element Analysis**: Counts, dominant element, missing elements, and beneficial element
- Initialize directly from a `Date` or from four explicit `Ganzhi` pillars

### 🎵 Nayin Five Elements (納音) — New in v1.4
- **Nayin**: All 30 traditional sound-element descriptions (海中金, 炉中火, 大林木, etc.)
- Each of the 60 Jiazi combinations maps to a Nayin via `Ganzhi.nayin`
- `Nayin.wuxing`: the underlying Five Element for each description

### 🏮 Earthly Branch Relationships — New in v1.4
- **Chong (六冲)**: Six clash pairs — `Dizhi.zi.chong` → `.wu`; `clashes(with:)`
- **LiuHe (六合)**: Six harmony pairs with resulting Wuxing element
- **SanHe (三合)**: Four triads with resulting element (申子辰水局, 寅午戌火局, etc.)
- **LiuHai (六害)**: Six harm pairs
- Query methods: `liuHe(with:)`, `formsLiuHe(with:)`, `sanHe(with:and:)`, `sanHeTriads`, `liuHai(with:)`, `formsLiuHai(with:)`

### 🎊 Traditional Chinese Festivals
- **12 festivals**: 春節, 元宵, 龍抬頭, 清明, 端午, 七夕, 中元, 中秋, 重陽, 冬至, 臘八, 小年
- `ChineseFestival.nextDate(from:converter:)` — finds the next Gregorian occurrence
- `Date.chineseFestival` — returns which festival (if any) falls on a given date
- `Date.nextChineseFestival()` — returns the soonest upcoming `(festival, date)` tuple
- Solar-term festivals (Qingming, Dongzhi) are detected automatically via `Jieqi`

### 🔌 Pluggable Special Day Sources — New in v2.1
- **`SpecialDaySource` protocol**: implement `specialDays(on:)` and `nextSpecialDay(after:)` to add custom event sources
- **`FestivalSource`**: built-in source for traditional festivals; inject a `ChineseFestivalContentProvider` for custom names/descriptions
- **`JieqiSource`**: built-in source for solar term transition days; inject a `JieqiContentProvider` for localised strings
- **`Date.specialDays(sources:)`**: returns all special days from the provided sources on a given date
- **`Date.nextSpecialDay(sources:)`**: returns the closest upcoming special day across all sources

### 🌙 Lunar Calendar Features
- **Lunar Days**: Traditional Chinese lunar month days (初一, 初二, etc.)
- **Moon Phases**: Eight traditional Chinese moon phases (朔, 望, 弦月, etc.)
- **Day Search**: Find upcoming occurrences of specific lunar days via `DayConverter`

### ⏰ Traditional Time Periods
- **Shichen** (時辰): Traditional 2-hour periods with exact start/end times
- **24 Solar Terms** (二十四節氣): Complete Jieqi system for seasonal transitions with health tips

### 🌤️ Solar Terms (節氣) API — New in v2.2+
- **`JieqiOccurrence`**: bundles a `Jieqi` identity with its `startDate` — no arithmetic required by callers
- **`Date.currentJieqi`** → `JieqiOccurrence?` — which period we're in and when it started
- **`Date.nextJieqi`** → `JieqiOccurrence?` — the next future transition with its exact date
- **`Jieqi.startDate(in:)`** → `Date?` — the start of the period containing a given date
- **`Jieqi.nextOccurrence(after:)`** → `JieqiOccurrence?` — the next time a specific jieqi occurs

### 🔥 Five Elements Theory
- **Wuxing** (五行): Wood, Fire, Earth, Metal, Water with generating (生) and controlling (克) cycles
- **Directions** (方位): Cardinal and intermediate directions with element associations
- **Seasons**: Seasonal element correspondences
- **Conversion Protocols**: Easy integration with custom types

### 🏛️ Advanced Features
- **28 Lunar Mansions** (二十八宿): Traditional star constellation system
- **Twelve Gods** (建除十二神): Traditional deity associations for days with recommended/prohibited actions
- **Event Models**: Rich event representation with titles and descriptions
- **Yin-Yang Theory**: Built-in polarity system throughout all components

## 📱 Platform Support

- **iOS**: 13.0+
- **macOS**: 10.15+
- **watchOS**: 6.0+
- **Swift**: 6.0+

## 🚀 Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/xiangyu-sun/ChineseAstrologyCalendar.git", from: "2.2.0")
]
```

Or add via Xcode:
1. File → Add Packages
2. Enter: `https://github.com/xiangyu-sun/ChineseAstrologyCalendar.git`
3. Click Add Package

## 📖 Usage Examples

### Basic Date Conversion

```swift
import ChineseAstrologyCalendar

let today = Date()

// Get Chinese calendar components
let chineseComponents = today.dateComponentsFromChineseCalendar()
print(chineseComponents.nian?.description ?? "")  // Year pillar (e.g., "癸卯")
print(chineseComponents.yue?.description ?? "")   // Month pillar (e.g., "甲子")
print(chineseComponents.riZhu?.description ?? "") // Day pillar (e.g., "乙丑")

// Formatted Chinese date string
print(today.chineseYearMonthDate)  // "癸卯年 二月初三"
```

### Four Pillars of Destiny (Bazi)

```swift
// Build a birth chart from a date (uses China Standard Time)
if let bazi = Bazi(date: Date()) {
    print(bazi.formattedDescription)
    // "年:甲辰 月:壬子 日:戊午 時:庚午"

    print(bazi.dayMaster.chineseCharacter)     // "戊" — the self element
    print(bazi.dayMasterElement.chineseCharacter) // "土"
    print(bazi.dominantElement.chineseCharacter)  // most frequent element
    print(bazi.missingElements.map(\.chineseCharacter)) // e.g. ["木"]
    print(bazi.beneficialElement.chineseCharacter) // element that supports the day master
}
```

### Earthly Branch Relationships

```swift
// Clash (六冲)
print(Dizhi.zi.chong)               // .wu
print(Dizhi.zi.clashes(with: .wu))  // true

// Six Harmonies (六合)
let pair = Dizhi.zi.liuHe(with: .chou)
print(pair?.resultingElement.chineseCharacter ?? "") // "土" (子丑合化土)

// Three Harmonies (三合)
let triad = Dizhi.shen.sanHe(with: .zi, and: .chen)
print(triad?.resultingElement.chineseCharacter ?? "") // "水" (申子辰三合水局)

// Six Harms (六害)
print(Dizhi.zi.formsLiuHai(with: .wei))  // true
```

### Nayin Sound Elements

```swift
let jiaZi = Ganzhi(gan: .jia, zhi: .zi)
print(jiaZi.nayin)            // 海中金
print(jiaZi.nayin.wuxing)     // .jin

let bingYin = Ganzhi(gan: .bing, zhi: .yin)
print(bingYin.nayin)          // 炉中火
```

### Traditional Chinese Festivals

```swift
let converter = DayConverter()

// Find the next Spring Festival
if let cny = ChineseFestival.springFestival.nextDate(from: Date(), converter: converter) {
    print("Next Spring Festival: \(cny)")
}

// Check if today is a festival
if let festival = Date().chineseFestival {
    print("Today is \(festival.chineseName): \(festival.meaning)")
}

// Get the nearest upcoming festival (any)
if let (festival, date) = Date().nextChineseFestival() {
    print("Next festival: \(festival.chineseName) on \(date)")
}
```

### Special Day Sources (Pluggable)

```swift
// Built-in sources
let today = Date().specialDays(sources: [FestivalSource(), JieqiSource()])

// Next upcoming special day across all sources
if let result = Date().nextSpecialDay(sources: [FestivalSource(), JieqiSource()]) {
    print("\(result.day.name) in \(result.daysUntil) day(s)")
}

// Custom source
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

### Solar Terms (節氣)

```swift
// Current period with its start date
if let current = Date().currentJieqi {
    print("In \(current.jieqi.chineseName) since \(current.startDate)")
}

// Next upcoming transition — startDate is ready to use, no arithmetic needed
if let next = Date().nextJieqi {
    print("\(next.jieqi.chineseName) starts on \(next.startDate)")
}

// When does a specific jieqi next occur?
if let occurrence = Jieqi.winterSolstice.nextOccurrence(after: Date()) {
    print("冬至: \(occurrence.startDate)")
}

// Start of the current period for a given date
if let start = Jieqi.grainBuds.startDate(in: Date()) {
    print("小滿 started on \(start)")
}
```

### Working with Traditional Time Periods

```swift
// Current Shichen (2-hour period)
if let currentShichen = Date().shichen {
    print("Current period: \(currentShichen.dizhi.chineseCharacter)")
    print("Started: \(currentShichen.startDate)")
    print("Ends: \(currentShichen.endDate)")
}
```

### Lunar Day and Moon Phase Information

```swift
// Working with lunar days
let lunarDay = Day.shiwu  // 15th day (full moon)
print(lunarDay.name)      // "十五"

// Search for upcoming lunar days
let converter = DayConverter()
let fullMoons = converter.find(days: [.shiwu], inNextMonths: 6)
for moon in fullMoons {
    print("Full moon: \(moon.date)")
}
```

### Five Elements and Zodiac

```swift
// Working with Ganzhi and elements
let ganzhi = Ganzhi(gan: .jia, zhi: .zi)  // 甲子
print(ganzhi.description)      // "甲子"
print(ganzhi.gan.wuxing)       // .mu (Wood element)

// Element relationships
let wood = Wuxing.mu
print(wood.sheng.chineseCharacter)  // "火" — Wood generates Fire
print(wood.ke.chineseCharacter)     // "土" — Wood controls Earth
```

## 🧪 Testing

Run the comprehensive test suite:

```bash
swift test
```

The package includes 200+ tests covering:
- Date conversion accuracy
- Ganzhi calculations
- Lunar phase correlations
- Solar term precision
- Element theory relationships
- Dizhi clash/harmony/harm relationships
- Bazi four pillars analysis
- Nayin sound element mappings
- Chinese festival date accuracy
- Integration scenarios

## 📚 Documentation

### Core Components

- **`Date` Extensions**: Seamless integration with Foundation's Date type
- **`Ganzhi`**: Heavenly Stem and Earthly Branch combinations
- **`Bazi`**: Four Pillars of Destiny birth chart
- **`Nayin`**: Sound element for each Ganzhi pair
- **`DizhiRelationship`**: Clash, harmony, and harm relationships
- **`ChineseFestival`**: Traditional festival date finder
- **`JieqiOccurrence`**: Pairs a `Jieqi` with its `startDate` for safe date handling
- **`SpecialDaySource`**: Protocol for pluggable special day providers
- **`FestivalSource`** / **`JieqiSource`**: Built-in special day sources
- **`Day`**: Lunar calendar day representations
- **`Shichen`**: Traditional 2-hour time periods
- **`Wuxing`**: Five Elements theory implementation
- **`ChineseMoonPhase`**: Traditional lunar phase system
- **`Jieqi`**: 24 Solar Terms with health tips, occurrence queries, and next/current helpers

### Architecture

```
ChineseAstrologyCalendar/
├── Date/                  # Date conversion and formatting
├── DizhiGanzhi/           # Core Ganzhi system + relationships + Nayin
├── FiveElements/          # Wuxing theory and relationships
├── Event/                 # Event modeling
├── Jieqi/                 # Solar terms, JieqiOccurrence, health tips
├── Moon/                  # Lunar phases
├── SpecialDaySources/     # FestivalSource, JieqiSource, pluggable providers
├── Bazi.swift             # Four Pillars of Destiny
├── ChineseFestival.swift  # Traditional festival dates
├── SpecialDay.swift       # SpecialDay + SpecialDaySource protocol
└── Math.swift             # Astronomical calculations
```

## 🔧 Dependencies

- [Swift Numerics](https://github.com/apple/swift-numerics): High-precision mathematical calculations
- [Astral](https://github.com/xiangyu-sun/Astral): Astronomical calculation utilities

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 🙏 Acknowledgments

- Traditional Chinese calendar algorithms and astronomical calculations
- Five Elements theory and relationships
- 28 Lunar Mansions historical references
- Community feedback and contributions

---

**Note**: This package provides traditional Chinese calendar calculations for cultural, educational, and historical purposes. Astronomical calculations are approximations suitable for general use but may not be appropriate for precise scientific applications.
