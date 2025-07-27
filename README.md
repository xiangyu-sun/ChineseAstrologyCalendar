# ChineseAstrologyCalendar

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Platform](https://img.shields.io/badge/platform-iOS%2013.0%2B%20%7C%20macOS%2010.14%2B%20%7C%20watchOS%205.0%2B-lightgrey.svg)](https://developer.apple.com/swift/)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE.md)

A comprehensive Swift package for working with traditional Chinese lunar calendar and astrology concepts. Convert between Gregorian and Chinese calendars, access zodiac animals, moon phases, five element theory, and much more.

## ✨ Features

### 📅 Calendar Conversions
- **Date Extensions**: Convert `Date` and `DateComponents` to Chinese calendar values
- **Year/Month/Day Pillars**: Access Ganzhi (干支) representations for complete calendar pillars
- **Traditional Formatting**: Display dates in proper Traditional Chinese format

### 🐲 Zodiac & Ganzhi System
- **Heavenly Stems** (天干): Complete enumeration of the 10 stems with Chinese characters
- **Earthly Branches** (地支): All 12 branches with zodiac animal associations
- **Sixty Jiazi** (六十甲子): The complete 60-year cycle combinations
- **Emoji Support**: Visual representations for all zodiac animals

### 🌙 Lunar Calendar Features
- **Lunar Days**: Traditional Chinese lunar month days (初一, 初二, etc.)
- **Moon Phases**: Eight traditional Chinese moon phases (朔, 望, 弦月, etc.)
- **Day Search**: Find upcoming occurrences of specific lunar days

### ⏰ Traditional Time Periods
- **Shichen** (時辰): Traditional 2-hour periods with exact start/end times
- **24 Solar Terms** (二十四節氣): Complete Jieqi system for seasonal transitions

### 🔥 Five Elements Theory
- **Wuxing** (五行): Wood, Fire, Earth, Metal, Water with relationships
- **Directions**: Cardinal and intermediate directions with element associations
- **Seasons**: Seasonal element correspondences
- **Conversion Protocols**: Easy integration with custom types

### 🏛️ Advanced Features
- **28 Lunar Mansions** (二十八宿): Traditional star constellation system
- **Twelve Gods**: Traditional deity associations for days
- **Event Models**: Rich event representation with titles and descriptions
- **Yin-Yang Theory**: Built-in polarity system throughout all components

## 📱 Platform Support

- **iOS**: 13.0+
- **macOS**: 10.14+
- **watchOS**: 5.0+
- **Swift**: 5.8+

## 🚀 Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/xiangyu-sun/ChineseAstrologyCalendar.git", from: "1.0.0")
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
print(chineseComponents.nian.description)   // Year pillar (e.g., "癸卯")
print(chineseComponents.yue.description)    // Month pillar (e.g., "甲子")
print(chineseComponents.riZhu.description)  // Day pillar (e.g., "乙丑")

// Formatted Chinese date string
print(today.chineseYearMonthDate)  // "癸卯年 二月初三"
```

### Working with Traditional Time Periods

```swift
// Current Shichen (2-hour period)
if let currentShichen = Date().shichen {
    print("Current period: \(currentShichen.dizhi.chineseCharactor)")
    print("Started: \(currentShichen.startDate)")
    print("Ends: \(currentShichen.endDate)")
}

// Get all Shichen for a specific date
let allPeriods = Date().shichens
for period in allPeriods {
    print("\(period.dizhi.name): \(period.dizhi.emoji)")
}
```

### Lunar Day and Moon Phase Information

```swift
// Working with lunar days
let lunarDay = Day.shiwu  // 15th day (full moon)
print(lunarDay.name)      // "十五"
print(lunarDay.moonPhase) // ChineseMoonPhase.望 (full moon)

// Search for upcoming lunar days
let converter = DayConverter()
if let nextFullMoon = converter.findNext(.shiwu, from: Date()) {
    print("Next full moon: \(nextFullMoon)")
}
```

### Five Elements and Zodiac

```swift
// Working with Ganzhi and elements
let ganzhi = Ganzhi(gan: .jia, zhi: .zi)  // 甲子
print(ganzhi.description)      // "甲子"
print(ganzhi.gan.wuxing)       // Wood element
print(ganzhi.zhi.zodiac.emoji) // 🐭 (Rat)

// Element relationships
let wood = Wuxing.wood
print(wood.generates)  // Fire
print(wood.destroys)   // Earth
```

### Advanced Features

```swift
// 28 Lunar Mansions
let mansion = LunarMansion.jiao  // 角宿
print(mansion.name)              // Chinese name
print(mansion.direction)         // Cardinal direction

// Twelve Gods system
let gods = TwelveGods.allCases
for god in gods {
    print("\(god.name): \(god.meaning)")
}

// Event modeling with rich metadata
let event = EventModel(
    title: "Spring Festival",
    date: Date(),
    description: "Traditional Chinese New Year celebration"
)
```

## 🧪 Testing

Run the comprehensive test suite:

```bash
swift test
```

The package includes extensive tests covering:
- Date conversion accuracy
- Ganzhi calculations
- Lunar phase correlations
- Solar term precision
- Element theory relationships
- Integration scenarios

## 📚 Documentation

### Core Components

- **`Date` Extensions**: Seamless integration with Foundation's Date type
- **`Ganzhi`**: Heavenly Stem and Earthly Branch combinations
- **`Day`**: Lunar calendar day representations
- **`Shichen`**: Traditional 2-hour time periods
- **`Wuxing`**: Five Elements theory implementation
- **`ChineseMoonPhase`**: Traditional lunar phase system
- **`Jieqi`**: 24 Solar Terms calculations

### Architecture

The package follows a modular design:

```
ChineseAstrologyCalendar/
├── Date/           # Date conversion and formatting
├── DizhiGanzhi/    # Core Ganzhi system
├── FiveElements/   # Wuxing theory and relationships
├── Event/          # Event modeling
├── Jieqi/          # Solar terms
├── Moon/           # Lunar phases
└── Math.swift      # Astronomical calculations
```

## 🔧 Dependencies

- [Swift Numerics](https://github.com/apple/swift-numerics): High-precision mathematical calculations
- [Astral](https://github.com/xiangyu-sun/Astral): Astronomical calculation utilities

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 🙏 Acknowledgments

- Traditional Chinese calendar algorithms and astronomical calculations
- Five Elements theory and relationships
- 28 Lunar Mansions historical references
- Community feedback and contributions

---

**Note**: This package provides traditional Chinese calendar calculations for cultural, educational, and historical purposes. Astronomical calculations are approximations suitable for general use but may not be appropriate for precise scientific applications.