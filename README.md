# ChineseAstrologyCalendar

A Swift package that exposes utilities for working with the traditional Chinese lunar calendar and astrology concepts. It offers conversions between the Gregorian and Chinese calendars, helpers for zodiac animals, moon phases and five element theory.

## Features

- **Date Conversions** – Extensions on `Date` and `DateComponents` to extract Chinese calendar values including year, month and day pillars (`GanZhi`).
- **Zodiac & GanZhi** – Enumerations of heavenly stems, earthly branches and the sixty Jiazi combinations with emoji and text representations.
- **Lunar Days & Phases** – `Day` models the days of a lunar month with associated `ChineseMoonPhase` values.
- **Two‑hour Periods** – `Shichen` calculates the traditional two‑hour intervals with start and end dates.
- **Day Search** – `DayConverter` locates upcoming occurrences of lunar days across months or years.
- **Five Elements** – Types describing the five elements (木、火、土、金、水) together with directions and seasons.
- **Formatters** – Convenience formatters for displaying dates in Traditional Chinese.

The package targets iOS 13+, macOS 10.14+ and watchOS 5+ as defined in `Package.swift`.

## Installation

Add the repository URL to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/xiangyu-sun/ChineseAstrologyCalendar.git", from: "1.0.0")
```

Then include `"ChineseAstrologyCalendar"` as a dependency for your target.

## Usage

```swift
import ChineseAstrologyCalendar

let today = Date()

// Chinese calendar components
let comps = today.dateComponentsFromChineseCalendar()
print(comps.nian)   // Ganzhi for the year pillar
print(comps.yue)    // Ganzhi for the month pillar
print(comps.riZhu)  // Ganzhi for the day pillar

print(today.chineseYearMonthDate) // formatted string such as "癸卯年 二月初三"

// Current shichen (two‑hour period)
if let period = today.shichen {
    print(period.dizhi.chineseCharactor) // e.g. "卯"
    print(period.startDate, period.endDate)
}
```

More examples can be found in the unit tests inside the `Tests` directory.

## Running Tests

```bash
swift test
```

## Releases

Pushing a tag that matches `v*` automatically triggers the release workflow.
The workflow builds the package, creates a GitHub release and uploads a
`ChineseAstrologyCalendar.zip` archive containing the release build.

## License

Licensed under the [MIT License](LICENSE.md).
