# Changelog

All notable changes to this package. Releases follow [Semantic Versioning](https://semver.org).

## 4.1.0

### Added
- Time-zone-aware solar terms: `Date.jieqi(in:)`, `isJieqiDay(in:)`, `currentJieqi(in:)`, `nextJieqi(in:)`, `Jieqi.startDate(in:timeZone:)` and `Jieqi.nextOccurrence(after:timeZone:)` reckon solar-term days on the calendar day of any time zone. The existing properties are unchanged and still use China Standard Time.

### Changed
- `ChineseAlmanac` reckons solar terms in its own `timeZone` (4.0.0 always used China Standard Time), and `AlmanacDay` exposes `timeZone`. With the default time zone, results are unchanged.
- `Date.chineseFestival(timeZone:)` matches solar-term festivals (清明, 冬至) in the given time zone. The `chineseFestival` property is unchanged.

## 4.0.0

Breaking release. See [MIGRATION.md](MIGRATION.md).

### Breaking
- `DisplayLanguage` is a struct instead of an enum; exhaustive `switch` statements need a `default:` branch. `allCases` now includes `.ru` and `.es`.
- Solar terms that begin in the afternoon (China time) are attributed to that day instead of the next. This affects `Date.jieqi`, `isJieqiDay`, `currentJieqi`, `nextJieqi`, `JieqiSource` and the 清明/冬至 festivals.

### Added
- `ChineseAlmanac`, `AlmanacDay` and `AlmanacText`: one call for the lunar date, pillars, solar term, festival, Twelve Gods, lunar mansion, moon phase and Shichen, already localized.
- `LunarDate` with `formatted(_:in:)` and `Date.lunarDate(_:)`.
- `DisplayLanguage.ru` / `.es`, `identifier`, `Codable`; Russian and Spanish festival and solar-term text through `localizedName(in:)` and the `Localized…ContentProvider`s.
- `TimeZone.chinaStandardTime` is public. `Date.chineseFestival(timeZone:)` and `Date.twelveGod(timeZone:)` are new.
- `Shichen` is `Sendable`.

### Deprecated
- `RussianFestivalContentProvider`, `SpanishFestivalContentProvider`, `RussianJieqiContentProvider` and `SpanishJieqiContentProvider`. Use `LocalizedFestivalContentProvider(language:)` / `LocalizedJieqiContentProvider(language:)`.
- `Date.chineseDate`, `chineseYearMonthDate`, `displayStringOfChineseYearMonthDateWithZodiac` and their `…GTM8` variants. Use `LunarDate`.

### Fixed
- `dateComponentsFromChineseCalendar(_:)` is safe to call concurrently.

## 3.2.0

### Added
- `Ganzhi`: public `gan`/`zhi`, `init?(_:_:)`, `init(jiaziIndex:)` and `jiaziIndex`.
- `LocalizedNaming` for Tiangan, Dizhi (plus `localizedHourName(in:)`), Ganzhi, Nayin, LunarMansion, FourSymbol and the `DizhiRelationship` kinds.
- `LunarMonth` and `Date.lunarMonth(_:)`.
- `DisplayLanguage(identifier:)`.

### Fixed
- `DisplayLanguage(locale:)` treated `zh-Hant-CN` as Simplified.
- Traditional-script names: 軫, 覆燈火, 子午沖.
- Astral is pinned by version, so this package can be depended on by version.

## 3.1.0
- Russian and Spanish content providers for festivals and solar terms.

## 3.0.0
- Solar terms reckoned by the China civil day. CI fixes.
