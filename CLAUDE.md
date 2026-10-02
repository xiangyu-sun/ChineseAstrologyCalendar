# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands for Development

### Building and Testing
```bash
swift build                    # Build the package
swift test                     # Run all tests
swift test --filter <TestName> # Run specific test class or method
swift test list               # List all available tests
```

### Code Quality
The project uses SwiftLint and SwiftFormat for code quality, configured as package plugins:
```bash
swift package format          # Format code using SwiftFormat
swift package lint           # Lint code using SwiftLint
```

### Release Management
Create releases by pushing git tags that match the pattern `v*` (e.g., `v4.0.0`). This triggers an automated workflow that builds the package and creates a GitHub release with a ZIP archive. Add the release's entry to `CHANGELOG.md` before tagging, and for major versions update `MIGRATION.md`. Tag only commits on `master` (v3.0.0/v3.1.0 were once tagged on an unmerged branch).

## Project Architecture

### Core Concept: Chinese Astrology Calendar System
This Swift package provides utilities for working with traditional Chinese lunar calendar and astrology concepts, focusing on date conversions and astronomical calculations.

### Key Architectural Components

#### 1. Ganzhi System (干支)
The foundation of Chinese calendar calculations:
- **Tiangan (天干)**: 10 Heavenly Stems (`jia` through `kui`)
- **Dizhi (地支)**: 12 Earthly Branches (`zi` through `hai`) 
- **Ganzhi**: Combinations of stem + branch forming 60-cycle periods
- **Jiazi**: Complete 60-combination cycle used for years, months, days, and hours

#### 2. Five Elements Theory (Wuxing 五行)
Philosophical system integrating throughout the calendar:
- **Elements**: Wood(木), Fire(火), Earth(土), Metal(金), Water(水)
- **Relationships**: Generating cycle (`sheng`) and controlling cycle (`ke`)
- **Mappings**: Each Tiangan and Dizhi maps to specific Wuxing elements
- **Associations**: Colors, flavors, directions, and seasons

#### 3. Calendar Conversion Architecture
Date conversion between Gregorian and Chinese lunar calendar:
- **Date Extensions**: Core functionality in `Date+DateComponents.swift`, `Date+Ganzhi.swift`
- **DateComponents Extensions**: Chinese calendar component extraction
- **Calendar Bridge**: Uses Foundation's Chinese calendar with custom timezone handling

#### 4. Lunar Day and Time Systems
- **Day Enum**: 30 lunar days (`chuyi` to `sanshi`) with Chinese text representations
- **MoonPhase**: Associated lunar phases for each day of the month
- **Shichen**: Traditional 2-hour time periods mapped to Dizhi branches
- **Time Calculations**: Hour-to-Dizhi mapping with start/end time intervals

#### 5. Event and Search System
- **EventModel**: Represents occurrences of specific lunar days
- **DayConverter**: Searches for upcoming lunar day occurrences across months/years
- **Formatters**: Traditional Chinese text formatting for dates and components

#### 6. SpecialDay Plugin Architecture
Pluggable sources for surfacing special calendar events on a given date:
- **SpecialDaySource** protocol: implement `specialDays(on:)` and `nextSpecialDay(after:)` to add custom event sources
- **FestivalSource**: built-in source for traditional Chinese festivals; inject a `ChineseFestivalContentProvider` for custom names/descriptions/category
- **JieqiSource**: built-in source for solar-term transition days; inject a `JieqiContentProvider` for custom display strings
- **Localized content providers**: `LocalizedFestivalContentProvider(language:)` and `LocalizedJieqiContentProvider(language:)` serve every `DisplayLanguage`; `Default*` providers are the Traditional Chinese originals. The `Russian*`/`Spanish*` providers are deprecated wrappers kept for 4.x; their tables live in `Localization/Tables/` as internal types
- **Date.specialDays(sources:)**: returns all special days from the provided sources on a given date
- **Date.nextSpecialDay(sources:)**: returns the closest upcoming special day across all sources
- **Date.nextChineseFestival(converter:)**: returns `(festival: ChineseFestival, date: Date)?` — the soonest upcoming festival
- **Date.chineseFestival**: exact-day check — returns the festival that falls on that specific date, or `nil`

#### 7. ChineseAlmanac (app entry point, v4)
- **`ChineseAlmanac(timeZone:language:)`**: `day(for:)` → `AlmanacDay`, `days(from:count:)` for ranges. Default time zone is China Standard Time
- **`AlmanacDay`**: `Equatable`/`Sendable` snapshot (lunarDate, pillars, jieqi, festival, twelveGod, lunarMansion, shichen, plus derived zodiac/moonPhase/isJieqiDay); `text` returns `AlmanacText` with every value localized
- **`LunarDate`** (`Date/LunarDate.swift`): year `Ganzhi` + `LunarMonth` + `Day`, `formatted(_ style:in:)`. Replaces the deprecated `Date+Year` string properties
- New almanac facts should be added to `AlmanacDay` and `AlmanacText` together, with a test in `V4APITests.swift`

#### 8. Localization
- **`DisplayLanguage`** is a struct (`zhHant`, `zhHans`, `en`, `ru`, `es`), not an enum, so adding a language is not source-breaking. Never make it an enum again
- Inside the package, switch on `language.base` (internal `BaseLanguage`: zhHant/zhHans/en) for types translated only into Chinese and English. Russian/Spanish fall back to English automatically. Types with their own ru/es text (`ChineseFestival`, `Jieqi`) check `language == .ru/.es` before switching on `base`
- `.zhHant` is canonical and must equal the type's `traditionalChineseName`/`chineseCharacter`. All canonical strings are Traditional script
- Long-form prose (Jieqi `healthTip`, TwelveGods almanac text) is intentionally not machine-translated
- Every `localizedName(in:)` must return a non-empty string for every `DisplayLanguage.allCases` value

#### 9. Time zones and solar terms
- Solar terms are reckoned by **calendar day in a time zone**: China (UTC+8) for the plain properties (`jieqi`, `isJieqiDay`, `currentJieqi`, `nextJieqi`), any zone via the `(in: TimeZone)` overloads (4.1). A term belongs to the day it begins, so `jieqi(in:)` samples the sun at the **last instant** of that day, never at noon (noon sampling put afternoon transitions a day late; fixed in 4.0)
- Clients that let users choose local vs China time (TianganDizhi's `useGTM8`) pass that time zone to the `(in:)` overloads; don't re-implement end-of-day alignment app-side
- `Bazi(date:)` always uses China Standard Time. Lunar dates, solar terms, festivals, Twelve Gods and Shichen take a time zone/calendar; `ChineseAlmanac` passes its own to all of them
- `dateComponentsFromChineseCalendar` uses a shared `DateFormatter` guarded by a lock; keep that if you touch it

### Breaking-change policy
- Breaking changes go in a major version, are listed in `CHANGELOG.md`, and get a section in `MIGRATION.md` with before/after code
- Prefer deprecating over removing: keep a deprecated forwarding API for one major version (`@available(*, deprecated, message: "Use …")`), then delete it in the next major. Deprecated in 4.x, to delete in 5.0: the `Russian*`/`Spanish*` content providers and the `Date+Year` string properties
- Behaviour changes (results differ for the same input) count as breaking even if signatures are unchanged
- Downstream packages (Bagua, JingluoShuxueCore in the same GitHub folder) depend on this one by version; bump their minimum when they need a new API

### Dependencies and External Libraries
- **swift-numerics**: Mathematical calculations for astronomical computations
- **Astral**: Astronomical calculations for solar terms and celestial positioning (pinned by version, `from: "1.2.0"` — never a branch, or downstream packages cannot depend on this one by version)
- **SwiftLint/SwiftFormat**: Code quality tools (as package plugins)

### Testing Strategy
Comprehensive test coverage organized by functional areas:
- **Integration Tests**: Full date conversion workflows
- **Component Tests**: Individual Ganzhi, Wuxing, and lunar day calculations  
- **Date Tests**: Specific date scenarios and edge cases
- **Formatting Tests**: Chinese text output validation

### Data Flow Patterns
1. **Gregorian Date Input** → Chinese calendar components via Foundation Calendar
2. **DateComponents** → Ganzhi calculations using traditional formulas
3. **Lunar Day Search** → Event models with formatted Chinese representations
4. **Astronomical Data** → Solar terms and moon phases via Astral dependency

### Platform Support
- iOS 13+, macOS 10.14+, watchOS 6+
- Swift 6.0+ toolchain required (swift-tools-version: 6.0)
- Cross-platform compatibility for all astronomical calculations

### Known Issues
- `swift test` may fail with `missing required module '_TestingInternals'` or `module compiled with Swift 6.2.4 cannot be imported by the Swift 6.3.3 compiler`. Root cause: a stale prebuilt `Testing.swiftmodule` in `.build` left over from an older toolchain. Fix: clear the cached modules and rerun —
  ```bash
  rm -f .build/*/debug/Modules/Testing.swiftmodule .build/*/debug/Modules/_TestingInternals.swiftmodule
  swift test
  ```
  After clearing the cache, CLI `swift test` runs normally.

### Key Extension Points
When adding new features, consider these integration points:
- **Wuxing relationships**: New element-based calculations 
- **Zodiac mappings**: Additional animal/branch associations
- **Calendar conversions**: New date formatting options
- **Astronomical events**: Integration with Astral library for celestial calculations